package tui.types;

interface Program {
	public var name : String;
	public var version : String;
	public var description : String;
	public var globalSwitches : Array<tui.types.Switch>;
	public var commands : Array<tui.types.Command>;

	public var usageCommandOverride : String;
}
