package tracer;

class Error {
	public static function error(text : String, ?source : String) {
		Template.template(Error, Colors.ErrorForeground, Colors.Error, text, source);
	}
}
