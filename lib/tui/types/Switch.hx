package tui.types;

typedef Switch = {

	// the name of the switch, this will be what is used to access and check the switch
	name: String,

	// a "long" name for the switch, typically "--name"
	?long: String,

	// a "short" name fot the switch, typically "-n" where n in the first letter of the name
	?short: String,

	// a description of the switch, is shown in the help output
	description: String,

	// does this switch expect a value? if true then it will
	// store the value immediately input after the switch
	?value : Bool,

	// for the default help, will group switches under different headings
	?group : String,
}
