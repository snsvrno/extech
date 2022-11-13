package aseprite.metadata;

import aseprite.ds.SpritesheetDef;
import aseprite.ds.Frame;

class Atlas {

	private var content : String = "";

	public static function make(sprite : SpritesheetDef) : String {

		var a = new Atlas();

		// adds the image data
		a.add('${sprite.image}');
		a.add('size: ${sprite.width},${sprite.height}');
		a.add('format: ${sprite.imageFormat}');
		a.add('filter: Nearest, Nearest');
		a.add('repeat: none');

		// sort the frames by name and position in the animation
		sprite.frames.sort(function(a,b){
			if (a.name > b.name) return 1;
			else if (a.name == b.name)
				if (a.pos > b.pos) return 1 else return -1;
			else return -1;
		});

		// adds each individual frame
		for (frame in sprite.frames)
			a.addFrame(frame);

		return a.content;
	}

	private function new() { }

	private function add(text : String) {
		content += "\n" + text;
	}

	private function addFrame(frame : Frame) {
		add(frame.name);

		addSub("rotate: false");
		addSub('xy: ${frame.x}, ${frame.y}');
		addSub('size: ${frame.width}, ${frame.height}');
		addSub('orig: ${frame.width}, ${frame.height}');
		addSub("offset: 0, 0");
		addSub("index: -1");
	}

	inline private function addSub(text : String) add("  " + text);

}
