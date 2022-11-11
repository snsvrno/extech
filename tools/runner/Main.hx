import tui.Switches;
using tools.Strings;
using StringTools;

import tracer.Debug.debug;
import tracer.Error.error;
import tracer.Warning.warning;
import tracer.Print.print;

import ansi.Paint.paint;
import ansi.colors.Style;
import tui.Formats.types;

private inline var NAME : String = "runner";

class Main extends tui.Script {

	private static var runnerCachePath : String;
	private static var runnerRootPath : String;

	public static function main() new Main();

	override function init() {
		name = "runner";
		version = "0.0.0";
		description = "builds haxe projects and runs their outputs";

		addSwitches({
			name: "source",
			short: "-s",
			description: "show the source of all printed lines",
		},{
			name: "skip build",
			long: "--skip-build",
			description: "run the expected binary without running any build tasks",
		},{
			name: "skip run",
			long: "--skip-run",
			description: "do not run anything",
		},{
			name: "files",
			long: "--files",
			description: "show all the files that are used to build",
		},{
			name: "local files",
			long: "--local-files",
			description: "show only the local files that are used to build",
		},{
			name: "quiet",
			long: "--quiet",
			short: "-q",
			description: "supresses all output that is not forced by switches",
		});
	}

	private function run() {

		sys.io.File.saveContent("file",'${Sys.args()}');

		// setting global switches
		if (!Switches.getFlag('source')) tracer.Level.showSource = false;
		if (Switches.getFlag('quiet')) tracer.Level.level = Warning;

		// checking if we have the appropriate parameters to run
		if (params.length != 1 || haxe.io.Path.extension(params[0]) != "hxml") {
			error('expecting 1 hxml file as a parameter', NAME);
			return;
		}

		debug('using hxml file ${paint(params[0], Green)}', NAME);

		var hxml = hxml.Hxml.load(params[0]);

		runnerRootPath = haxe.io.Path.join([Sys.getCwd(),".runner"]);
		runnerCachePath = haxe.io.Path.join([runnerRootPath, "cache"]);

		// checking the cache so we know what commands to run
		var ok = hxml.beforeEachRun(checkBuild, postBuild, '--xml "$runnerCachePath"');
		if (!ok) {
			debug('building has been stopped, quitting',NAME);
			return;
		}

		//////////////////////////////////////////////////////////////////////
		// checks if we have something that we should be running

		if (!Switches.getFlag("skip run")) {

			var targets = hxml.getTargets();
			debug('found targets: ${types(targets)}', NAME);
			if (targets.length == 1) runTarget(targets[0]);
			// assuming that the last viable target is what we want to run
			else if (targets.length > 0) runTarget(targets.pop());

		}
	}

	/**
		* attempts to run the given command,
		* expecting either a `hl` or `neko` bitcode
		* file.
		*/
	private static function runTarget(executable : String) {
		var command = "";
		var extension = haxe.io.Path.extension(executable);

		switch(extension) {
			case "hl": command = 'hl $executable';
			case "n": command = 'neko $executable';

			case _:
				error('unsupported target: ${paint(executable, Yellow)}', NAME);
				return;
		}

		print('running ${paint(command, Cyan)}:', NAME);

		var process = new sys.io.Process(command);

		var code = process.exitCode(false);
		while(code == null) {
			// this is where i need to check for output from the program
			try {
				// captures the output, like trace
				var output = process.stdout.readLine();
				print(paint(">> ",White,Dim) + OutputParser.pretty(output));

				code = process.exitCode(false);
			} catch (e) { break; }
		}

		process.close();
		
	}

	/**
		* callback that is run before the build, used to check if we should
		* actually run the build
		*/
	private static function checkBuild(commands : Array<hxml.ds.Command>) : hxml.ds.CheckResult {
		var hash = makeHash(commands);
		var lines : Int = 0;

		var displayFiles = Switches.getFlag("files");
		var displayLocalFiles = Switches.getFlag("local files");

		var files = getRunnerCache(hash);
		if (files == null) return Build();

		var build = false;
		var fileNames = [ for (f in files.keys()) f ];
		fileNames.sort((a,b) -> if (a > b) return 1 else return -1);

		for (file in fileNames) {
			var timestamp = files.get(file);
		// for (file => timestamp in files) {
	
			// checks is this file does not exist anymore.
			if (!sys.FileSystem.exists(file)) {
				build = true;
				print('${ansi.Paint.paint(file,Green)} no longer exists.', NAME);
				lines += 1;
				continue;
			}
	
			// checks the timestamp
			var stats = sys.FileSystem.stat(file);
			if(stats.mtime.toString() != timestamp.toString()) {
				print('${ansi.Paint.paint(file, Green)} has changed', NAME);
				lines += 1;
				build = true;
			} else if (displayFiles) {
				print('${ansi.Paint.paint(file, White, Dim)}', NAME);
				lines += 1;
			} else if (displayLocalFiles && !file.contains("haxelib") && !file.contains("haxe")) {
				tracer.Print.printForce('${ansi.Paint.paint(file, White, Dim)}', NAME);
				lines += 1;
			}

		}

		var skipbuild = Switches.getFlag("skip build");
		if (build && !skipbuild) return Build(lines);
		else {
			if (!skipbuild) for (c in commands) {
				if (c.command.substr(0,5) == "--cmd") return ExecuteOnly(lines);
			}
			return Skip(lines);
		}
	}

	/**
		* callback that is run after a build, will check all the files
		* that were used to make the build and store them in the cache
		* so we can check next time if anything has changed
		*/
	private static function postBuild(result : hxml.ds.RunResult) {
		var hash = makeHash(result.commands);

		// makes a list of all the buildfiles
		var watchFiles = makeBuildFilesList();
		sys.FileSystem.deleteFile(runnerCachePath);

		saveRunnerCache(hash, watchFiles);
	}

	/**
		* creates a unique hash of the commands given
		*/
	private static function makeHash(commands : Array<hxml.ds.Command>) : String {
		var string = "";
		commands.sort((a,b) -> if (a.command.length < b.command.length) return -1 else return 1);
		for (c in commands) string += c.command;
		return haxe.crypto.Sha256.encode(string);
	}

	/**
		* reads the haxe engine xml output to determine
		* what files were used in building the command
		*
		* all commands use the same temporary cache location
		* so this needs to be run after the appropriate build
		* command is run in order to get meaningful output
		*/
	private static function makeBuildFilesList() : Map<String,Date> {
		var watchFiles : Map<String,Date> = new Map();

		// reading the xml output of the build
		var content = sys.io.File.getContent(runnerCachePath);
		var xml = haxe.xml.Parser.parse(content);
		for (el in xml.elements()) {
			for (cs in el.elements()) {
				var file = cs.get("file");
				// debug('src file : $file');
				if (file != null && watchFiles.get(file) == null) {
					var stats = sys.FileSystem.stat(file);
					watchFiles.set(file, stats.mtime);
				}
			}
		}

		return watchFiles;
	}

	/**
		* saves the filelist to the filename in the runner cache
		* folder
		*/
	private static function saveRunnerCache(fileName : String, fileList : Map<String, Date>) {
		var path = haxe.io.Path.join([runnerRootPath, fileName]);
		var ser = new haxe.Serializer();
		ser.serialize(fileList);
		sys.io.File.saveContent(path,ser.toString());
	}

	/**
		* gets the file list for the given file,
		*
		* the filename is the command hash
		*/
	private static function getRunnerCache(fileName : String) : Null<Map<String, Date>> {
		var path = haxe.io.Path.join([runnerRootPath, fileName]);
		if (!sys.FileSystem.exists(path)) return null;

		var contents = sys.io.File.getContent(path);
		return haxe.Unserializer.run(contents);
	}

}
