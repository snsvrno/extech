// the generic function that is used for defining the messages,
// probably shouldn't call this.

package tracer;

import ansi.colors.Style;
import ansi.colors.ColorTools;

using tracer.Levels;

inline function template(type : tracer.Levels, Fg : ansi.colors.Color, Bg : ansi.colors.Color, text : String, ?source : String) {

	// FIX: for some reason using the `getSize` breaks process. current theory is that it
	// causes issues with how haxe communicates with the process

	// var size = ansi.Command.getSize();

	if (tracer.Level.level.isGte(type)) {

		var pre = ansi.Paint.paint(" " + type.toString() + " ", Fg, Bg, Bold);
		var src = if (source != null && tracer.Level.showSource) ansi.Paint.paint(" " + source + " ", Colors.SourceForeground, Colors.Source, Dim) else "";

		Sys.println('$pre$src ${ansi.Paint.paintPreserve(text, Bg, null, Dim)}');
		}

	/*var headerLength = ColorTools.length(pre) + ColorTools.length(src) + 1;
	
	var lines = ColorTools.splitLength(text, size.c - headerLength);

	for (i in 0 ... lines.length) {
		Sys.println('$pre$src ${ansi.Paint.paintPreserve(lines[i], Bg, null, Dim)}');
	}
	*/


	return;
}

