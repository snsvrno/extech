package debug;

class Console {
	public static function setup(console : h2d.Console) {
		console.addCommand("watch", null, [{name:"name", t:AString}], watch);
		console.addCommand("clearWatch", null, [], debug.Debug.removeAllWatch);
		console.addCommand("saveWatch", null, [] , debug.Debug.saveWatches);
		console.addCommand("loadWatch", null, [] , debug.Debug.loadWatches);
		console.addCommand("listWatch", null, [] , listWatches);
	}

	private static function watch(name : String) {
		var value = debug.Debug.getValue(name);
		if (value == null) debug.Debug.console.log('nothing named $name');

		debug.Debug.updateWatch(name, value);
	}

	private static function listWatches() {
		var names = debug.Debug.getValues();
		debug.Debug.console.log(names.join(", "));
	}

}
