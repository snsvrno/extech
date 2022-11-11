package tools;

using tools.Strings;

class Fs {
	
	/**
		* recursively gets all the files of a given extension(s) inside a folder.
		*/
	public static function getFilesByExt(path : String, ...ext : String) : Array<String> {
		var found = [];
		for (f in sys.FileSystem.readDirectory(path)) {
			var fullPath = haxe.io.Path.join([path, f]);

			if (sys.FileSystem.isDirectory(fullPath)) {
				for (of in getFilesByExt(fullPath, ... ext)) found.push(of);
			} else {
				var extension = haxe.io.Path.extension(f);
				for (e in ext) if (e == extension) found.push(fullPath);
			}
		}
		return found;
	}

	/**
		* reads a text file and returns the line
		*/
	public static function contentLines(path : String) : Array<String> {
		var contents = sys.io.File.getContent(path);
		return contents.lines();
	}
}
