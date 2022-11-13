package debug;

class Debug {

	private static var init : Bool = false;

	private static var console : h2d.Console;
	private static var watchesContainer : h2d.Flow;
	private static var watches : Map<String, Watch> = new Map();

	private static var updateQueue : Array<(dt:Float) -> Bool> = [];

	public static function attach(parent : h2d.Object) {
		if (!init) {
			console = new h2d.Console(hxd.res.DefaultFont.get());
			watchesContainer = new h2d.Flow();
			watchesContainer.verticalAlign = Top;
			watchesContainer.horizontalAlign = Right;
			watchesContainer.layout = Vertical;
		}

		removeAllWatch();

		parent.addChild(console);
		parent.addChild(watchesContainer);
	}

	public static function updateWatch(name : String, value : String) {
		var w  : Null<Watch> = watches.get(name);
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

}
