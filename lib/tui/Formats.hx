package tui;

import ansi.colors.Style;
import ansi.Paint.paint;

class Formats {

	public static function tab(?n : Int = 1) {
		for (_ in 0 ... n) Sys.print("  ");
	}

	public static function space(?n : Int = 1) {
		for (_ in 0 ... n) Sys.print(" ");
	}

	public static function unknownCommand(cmd : String) : String
		return paint(cmd, Yellow, Style.Bold | Style.Underline);

	public static function option(text : String) : String
		return paint(text, Green);

	public static function value(text : String) : String
		return ansi.Paint.paintPreserve(text, Yellow);

	public static function parameter(text : String) : String
		return paint(text, Magenta);

	public static function parameterUsage(text : String) : String
		return paint("<", White, Style.Dim) + parameter(text) + paint(">", White, Style.Dim);

	public static function command(text : String, ?style : Style = None) : String
		return paint(text, Blue, style);

	public static function types(anything : Dynamic) : String {
		switch(Type.typeof(anything)) {
			case TNull: return paint("null", Cyan);
			case TInt: return paint(anything + "", Green);
			case TFloat: return paint(anything + "", Blue);
			case TBool: return paint(anything + "", Magenta);
			case TObject:
				var keys = Reflect.fields(anything);

				var s = paint("{ ",White, Style.Dim);
				for (k in keys) {
					var value = Reflect.getProperty(anything,k);
					s += '${paint(k,Blue)} ${paint(":",White, Style.Dim)} ${types(value)}${paint(",",White, Style.Dim)}';
				}
				s += paint(" }",White, Style.Dim);
				return s;

			case TClass(c):
				if (Std.isOfType(anything, Array)) {
					var array = cast(anything, Array<Dynamic>);

					var s = paint("[ ",White, Style.Dim);
					for (a in array)
						s += '${types(a)}${paint(",",White, Style.Dim)}';
					s += paint(" ]",White, Style.Dim);

					return s;
				} else if (Std.isOfType(anything, String)) {
					return paint(anything + "", Yellow);
				}


				return paint(c + "", Red);

			case _:
				return anything.toString();
		}
	}
}
