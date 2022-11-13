package packer;

import packer.ds.Box;
import packer.ds.PackedBox;
import packer.ds.Options;

class Pack {

	public static function pack(boxes : Array<Box>, ?options : Options) : Array<PackedBox> {
		if (options == null) options = { };
		packer.ds.Options.defaults(options);

		var packed : Array<PackedBox> = [ ];

		switch(options.method) {
			case Simple: return packer.Simple.pack(boxes, options);
		}

		return packed;
	}
}
