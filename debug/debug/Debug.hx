package debug;

using tools.Strings;

class Debug {

	private static var name : String;
	private static var init : Bool = false;

	public static var console : h2d.Console;
	private static var watchesContainer : h2d.Flow;
	private static var watches : Map<String, Watch> = new Map();

	private static var values : Map<String, String> = new Map();

	private static var updateQueue : Array<(dt:Float) -> Bool> = [];

	public static function attach(parent : h2d.Object, name : String) {
		Debug.name = name;

		if (!init) {
			watchesContainer = new h2d.Flow();
			watchesContainer.verticalAlign = Top;
			watchesContainer.horizontalAlign = Left;
			watchesContainer.layout = Vertical;

			console = new h2d.Console(hxd.res.DefaultFont.get());
			Console.setup(console);
		}

		parent.addChild(console);
		parent.addChild(watchesContainer);

		removeAllWatch();
		loadWatches();
	}

	public static function updateWatch(name : String, value : String, ?ifExists : Bool = false) {
		var w  : Null<Watch> = watches.get(name);
		if (w == null && ifExists) return;
		if (w == null) {
			w = new Watch(name, watchesContainer);
			watches.set(name, w);
		}
		var updater = w.setValue(value);
		if (updater != null) updateQueue.push(updater);
	}

	public static function removeWatch(name : String) {
		var x = watches.get(name);
		if (x != null) {
			x.remove();
			watches.remove(name);
		}
	}

	public static function removeAllWatch() {
		for (k => v in watches) {
			watchesContainer.removeChild(v);
			v.remove();
			watches.remove(k);
		}
	}

	public static function update(dt : Float) {
		var l = updateQueue.length;
		for (i in 0 ... l) {
			var q = updateQueue[l-i-1];
			if (q(dt)) updateQueue.remove(q);
		}
	}

	public static function setValue(name : String, value : String) {
		values.set(name, value);
		// updates the watch if it is currently being watched
		updateWatch(name, value, true);
	}

	public static function getValue(name : String) : Null<String> {
		return values.get(name);
	}

	public static function saveWatches() {
		var watches = [ for (v in watches.keys()) v ];
		var content = '${name}\n${watches.join(',')}';

		if (sys.FileSystem.exists('.watches')) {
			var content = sys.io.File.getContent('.watches');
			var clines = content.lines();
			while(clines.length > 0) {
				if (clines[0] == name) {
					clines.shift();
					clines.shift();
				} else {
					content += "\n" + clines.shift();
					content += "\n" + clines.shift();
				}
			}
		}
		sys.io.File.saveContent('.watches', content);
	}

	public static function getValues() : Array<String> {
		return [ for (f in values.keys()) f ];
	}

	public static function loadWatches() {
		if (sys.FileSystem.exists('.watches')) {
			var content = sys.io.File.getContent('.watches');
			var clines = content.lines();
			while(clines.length > 0) {
				if (clines[0] == name) {
					clines.shift();
					var watches = clines.shift().split(',');
					for (w in watches) {
						updateWatch(w, getValue(w));
					}
				} else {
					content += "\n" + clines.shift();
					content += "\n" + clines.shift();
				}
			}
		}
	}

}
