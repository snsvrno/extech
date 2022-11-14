package debug;

class Helpers {
	public static function watch(name : String, value : Dynamic) {
		debug.Debug.setValue(name, '$value');
	}
}
