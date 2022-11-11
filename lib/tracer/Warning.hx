package tracer;

class Warning {
	public static function warning(text : String, ?source : String) {
		Template.template(Warning, Colors.WarningForeground, Colors.Warning, text, source);
	}
}
