package tui.types;

/**
	* object for a fuction command
	*
	* usage: create a instantaniable class that implements this interface and
	* add it to the `script`. this command will then be available when running
	* that script
	*/
@:autoBuild(tui.macros.Command.defaults())
interface Command {

	/*** the internal name of the command */
	public var name : String;

	/*** in the command normally hidden from the list of available commands */
	public var hidden : Bool;

	/*** the one line description of the command */
	public var description : String;

	/*** longer description that is displayed on the man page */
	public var manDescription : String;

	/*** the display name of the command, that will be displayed in the man */
	public var display : Null<String>;

	public var switches : Array<tui.types.Switch>;
	public var commands : Array<tui.types.Command>;

	public function run(...args : String) : Void;

	/*** use to check if the given parameter is a command. */
	public function check(param : String) : Bool;

}
