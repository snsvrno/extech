package tracer;

import ansi.colors.Style;
using tracer.Levels;

class Print {
	inline public static function print(text : String, ?source : String, ?newline : Bool = true) {
		if (tracer.Level.level.isGte(Regular)) printForce(text, source, newline);
	}

	public static function printForce(text : String, ?source : String, ?newline : Bool = true) {
		var src = if (source != null && tracer.Level.showSource) ansi.Paint.paint(" " + source + " ", Black, Magenta, Dim) + " " else "";

		if (newline) Sys.println('$src$text');
		else Sys.print('$src$text');
	}
}
