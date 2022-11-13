package aseprite.tools;

using aseprite.ds.Frame;

import aseprite.ds.Frame;
import aseprite.ds.Tag;
import aseprite.Name.NAME;

import sn.ds.Color;
class Ase {

	/**
		* creates a 'frame' for every image that should be created
		* for the given aseprite file
		*/
	public static function getFrames(path : String, ?baseName : String) : Array<Frame> {
		var frames = [ ];

		var rawData = sys.io.File.getBytes(path);
		var aseData = ase.Ase.fromBytes(rawData);

		if (baseName == null) baseName = haxe.io.Path.withoutExtension(path);

		// this is only on the first frame?
		var tags = getTags(aseData.frames[0]);

		for (fi in 0 ... aseData.frames.length) {
			var matchedTags = [];
			var frame = aseData.frames[fi];
			var f = getPixels(frame, aseData);

			f.file = path;

			// adds the tags to the frame
			for (t in tags) {
				if (t.start <= fi && fi <= t.end) {
					matchedTags.push(t);
				}
			}

			if (matchedTags.length == 0) {
				f.name = baseName;
				f.pos = fi;
				frames.push(f);
			} else for (t in matchedTags) {
				var newFrame = f.clone();
				newFrame.name = baseName+"-"+t.name;
				newFrame.pos = fi - t.start;
				frames.push(newFrame);
			}
		}

		return frames;
	}

	private static function getTags(data : ase.Frame) : Array<Tag> {
		var tags = [ ];

		for (c in data.chunks) switch(c.header.type) {
	
			case ase.types.ChunkType.TAGS:
				var tagChunk : ase.chunks.TagsChunk = cast(c);
				for (tag in tagChunk.tags) {
					tags.push({
						name: tag.tagName,
						start: tag.fromFrame,
						end: tag.toFrame,
					});
				}

			default:
		}

		return tags;
	}

	private static function getPixels(frame : ase.Frame, asedata : ase.Ase) : Frame {
		// allocates the stream that becomes the image, stored in a 1D array
		var iw = asedata.width;
		var ih = asedata.height;
		var newdata = haxe.io.Bytes.alloc(iw * ih * 4);

		for (li in 0 ... asedata.layers.length) {
			// skip hidden layers
			if (!asedata.layers[li].visible) continue;

			var cel = frame.cel(li); // the crossection of the layer and the frame
			if (cel == null) continue; // the layer is not used in the current frame

			var cursor = 0;

			for (jpx in 0 ... ih) {
				cursor = jpx * iw * 4;
				for (ipx in 0 ... iw) {

					var rawPixel = cel.getPixel(ipx - cel.xPosition, jpx - cel.yPosition);

					// create an abstract so that we get some helper functions.
					// the colors are all backwards though, kept getting confused so the
					// r,g,b does not actually correspond to r,g,b but the resulting Bytes
					// data is written correctly so that the png that is generated looks
					// like (and has the right colors) as the aseprite file.
					var color = new Color(rawPixel);

					// if this is as solid color, we will just
					// overwrite the space and not worry if there was
					// something else in the data
					if (color.ai == 255) {
						newdata.set(cursor, color.ai);
						newdata.set(cursor + 1, color.bi);
						newdata.set(cursor + 2, color.gi);
						newdata.set(cursor + 3, color.ri);
					
					// otherwise we'll multiply it together to get the new
					// color.
					} else {
						newdata.set(cursor, Math.floor(Math.min(newdata.get(cursor) + color.ai, 255)));
						newdata.set(cursor + 1, Math.floor(color.af * color.bi + newdata.get(cursor + 1) * (1 - color.af)));
						newdata.set(cursor + 2, Math.floor(color.af * color.gi + newdata.get(cursor + 2) * (1 - color.af)));
						newdata.set(cursor + 3, Math.floor(color.af * color.ri + newdata.get(cursor + 3) * (1 - color.af)));
					}

					cursor += 4;
				}
			}

		}

		return {
			height: ih,
			width: iw,
			data: newdata,
			duration: frame.header.duration,
		};
	}

}
