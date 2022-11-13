package toml.loader;

import result.Result;

class All {
	public static function load(directory : String, ?extension : String = "toml") : Result<Dynamic, String> {
		var object = { };

		for (file in sys.FileSystem.readDirectory(directory)) {

			var path = haxe.io.Path.join([directory, file]);
			var name = haxe.io.Path.withoutExtension(file);

			if (sys.FileSystem.isDirectory(path)) {

				switch(load(path, extension)) {
					case Error(err): return Error(err);
					case Ok(data):
						Reflect.setProperty(object, name, data);
				}

			} else {

				if (haxe.io.Path.extension(file) != extension) continue;

				var contents = sys.io.File.getContent(path);
				switch(toml.Toml.parse(contents, path)) {
					case Error(err): return Error(err);
					case Ok(data):
						Reflect.setProperty(object, name, data);
				}
			}
		}

		return Ok(object);
	}
}
