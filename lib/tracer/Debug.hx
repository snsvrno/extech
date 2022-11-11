package tracer;

using tracer.Levels;	

class Debug {
	public static function debug(text : String, ?source : String) {
		Template.template(Debug, Colors.DebugForeground, Colors.Debug, text, source);
	}

	// NOTE: created because of counting debug print lines in lib/hxml
	// not ideal
	public static function debugRun(func:() -> Void) {
		if (tracer.Level.level.isGte(Debug)) func();
	}
}
