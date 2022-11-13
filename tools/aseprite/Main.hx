import tracer.Error.error;
import tracer.Debug.debug;

inline var NAME : String = "aseprite";

class Main extends tui.Script {

	public static function main() new Main();

	override function init() {
		name = "aseprite";
		version = "0.0.0";
		description = "tool to create spritesheets from aseprite files";

		addSwitches({
			name: "output",
			long: "--output",
			short: "-o",
			description: "the resulting file, do not include the extension",
			value: true,
		},{
			name: "folder",
			long: "--folder",
			description: "a path to scan for aseprite files, is recursive, multiple can be included",
			value: true,
		}/*,{
			name: "format",
			long: "--format",
			short: "-f",
			description: 'the format for the definition file. supports: ${aseprite.ds.Format}',
			value: true,
		}*/);

		tracer.Level.showSource = false;
	}

	private function run() {

		var output = tui.Switches.getValues("output");
		var folder = tui.Switches.getValues("folder");

		/*
		var format : Null<aseprite.ds.Format> = null;
		var rawFormat = tui.Switches.getValues("format");
		if (rawFormat != null) switch(rawFormat[0].toLowerCase()) {
			case "json": format = Json;
			case "atlas": format = Atlas;
			case other:
				error('unknown format $other', NAME);
				return;
		}
		*/

		if (output == null) {
			error('no output, use ${ansi.Paint.paint("--output", Blue)}');
			return;
		}

		if (folder == null) {
			error('no input, use ${ansi.Paint.paint("--folder", Blue)}');
			return;
		}

		aseprite.Process.folder(folder[0], output[0]);
		// aseprite.Process.combine(source[0], output[0], { format: format });

	}
}
