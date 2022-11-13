package;

import ansi.Paint.paint;
import ansi.colors.Style;

class OutputParser {

	private static var traceRegex : EReg = new EReg('([^:]*):([0-9]*):(.*)',"");
	private static var throwRegex : EReg = new EReg('Called from ([^\\ ]*) \\(([^\\ ]*) line ([0-9]*)\\)',"");

	public static function pretty(string : String) : String {
		if(traceRegex.match(string)){
			return paint(traceRegex.matched(1), Yellow, Bold) +
				paint(":", White, Dim) +
				paint(traceRegex.matched(2), Magenta) +
				paint(":", White, Dim) +
				traceRegex.matched(3);
		} else if (throwRegex.match(string)) {
			return paint("Called from ", White, Dim) +
				paint(throwRegex.matched(1), Magenta, Underline) +
				paint(" (", White, Dim) +
				paint(throwRegex.matched(2), White, Bold) +
				paint(" line ", White, Dim) +
				paint(throwRegex.matched(3), Green, Bold) +
				paint(")", White, Dim);

		}

		return string;
	}
}
