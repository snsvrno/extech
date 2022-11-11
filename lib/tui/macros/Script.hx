package tui.macros;

using tui.macros.Helpers;

import haxe.macro.Expr;
import haxe.macro.Context;

class Script {
	public static function build() : Array<Field> {
		var fields = Context.getBuildFields();

		var init = null;
		var hasRun = false;

		for (f in fields) {
			if (f.name == "run") hasRun = true;
			else if (f.name == "init") init = f;
		}

		if (init != null && hasRun) {
			switch (init.kind) {
				case(FFun(f)):
					f.expr = macro {
						${f.expr}
						_runFunc = run;
					};
				case _:
			}

		}

		return fields;
	}
}
