package packer;

import packer.ds.Box;
import packer.ds.PackedBox;
import packer.ds.Options;

class Simple {

	public static function pack(boxes : Array<Box>, options : Options) : Array<PackedBox> {
		var packed : Array<PackedBox> = [ ];

		// sort it by height
		boxes.sort((a,b) -> if (a.h > b.h) return 1 else return -1);

		var x = options.padding;
		var y = options.padding;
		var yh = 0;

		while(boxes.length > 0) {
			var box = boxes.pop();

			if (x + options.padding + box.w > options.width) {
				x = options.padding;

				if (y + options.padding + box.h > options.height) {
					throw 'not implemented yet';
					// need to make a new image
				}

				y += yh + options.padding;

			}

			packed.push({
				id: box.id,
				x: x,
				y: y,
			});

			x += options.padding + box.w;
			if (yh < box.h) yh = box.h;
		}

		return packed;
	}
}
