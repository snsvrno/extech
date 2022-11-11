package tracer;

enum abstract Levels(Int) to Int from Int {
	var Error = 0;
	var Warning = 1;
	var Regular = 2;
	var Debug = 3;
}

function toString(l:Levels) : String {
	switch(l) {
		case Error: return "error";
		case Warning: return "warning";
		case Debug: return "debug";
		case Regular: return "";
	}
}

function isGte(l1 : Levels, l2 : Levels) : Bool {
	return cast(l1, Int) >= cast(l2, Int);
}
