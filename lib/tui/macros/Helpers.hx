package tui.macros;

import haxe.macro.Expr;

class Helpers {

	public static function hasField(array : Array<Field>, fieldName : String) : Bool {
		for (f in array) if (f.name == fieldName) return true;
		return false;
	}

	public static function getField(array : Array<Field>, fieldName : String) : Null<Field> {
		for (f in array) if (f.name == fieldName) return f;
		return null;
	}
}
