package aseprite.ds;

typedef Frame = {
	?id : String,
	?duration : Int,

	data : haxe.io.Bytes,
	width : Int,
	height : Int,

	?x : Int,
	?y : Int,

	?name : String,
	?file : String,

	?pos : Int,
}

function clone(frame : Frame) : Frame {
	return {
		duration: frame.duration,
		data: frame.data,
		width: frame.width,
		height: frame.height,
		name: frame.name,
		file: frame.file,
		pos: frame.pos,
		x: frame.x,
		y: frame.y,
	};
}

function get(array : Array<Frame>, id : String) : Null<Frame> {
	for (a in array) if (a.id == id) return a;
	return null;
}
