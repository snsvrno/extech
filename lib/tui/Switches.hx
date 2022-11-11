package tui;

class Switches {

	private static var flags : Array<String> = [];
	private static var values : Map<String, Array<String>> = new Map();

	public static function getFlag(name : String) : Bool {
		return flags.contains(name);
	}

	public static function setFlag(name : String) {
		if (!flags.contains(name)) flags.push(name);
	}

	public static function setValue(name : String , value : String) {
		var vs = if (values.exists(name)) values.get(name); else [ ];
		vs.push(value);
		values.set(name, vs);
	}

	public static function getValues(name : String) : Null<Array<String>> {
		return values.get(name);
	}
}
