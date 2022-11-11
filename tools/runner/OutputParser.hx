package;

import ansi.Paint.paint;
import ansi.colors.Style;

class OutputParser {

	private static var traceRegex : EReg = new EReg('([^:]*):([0-9]*):(.*)',"");

	public static function pretty(string : String) : String {
		if(traceRegex.match(string)){
			return paint(traceRegex.matched(1), Yellow, Bold) +
				paint(":", White, Dim) +
				paint(traceRegex.matched(2), Magenta) +
				paint(":", White, Dim) +
				traceRegex.matched(3);
		}

		return string;
	}
}
