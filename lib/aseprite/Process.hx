package aseprite;

using aseprite.ds.Frame;

import tracer.Debug.debug;

import aseprite.Name.NAME;
import aseprite.ds.SpritesheetDef;
import aseprite.ds.Options;

class Process {

	/**
		* create a combined spreadsheet from the
		* aseprite files in the given directory
		*/
	public static function folder(path : String, output : String, ?options : Options) {
		if (options == null) options = { };
		aseprite.ds.Options.defaults(options);

		var frames = [ ];

		///////////////////////////////////////////////////////////////
		// getting the frames that will be used in the final image
		for (p in tools.Fs.getFilesByExt(path, "aseprite", "ase")) {
			var name = haxe.io.Path.withoutExtension(p).substr(path.length);
			debug('adding file ${ansi.Paint.paint(name, Green)}', NAME);
			for (f in aseprite.tools.Ase.getFrames(p, name)) frames.push(f);
		}

		//////////////////////////////////////////////////////////////
		// sorting the frames
		var boxes : Array<packer.ds.Box> = [];
		for (f in frames) {
			var hash = sn.Hash.gen(10);
			f.id = hash;
			boxes.push({
				id: hash,
				w: f.width,
				h: f.height
			});
		}

		//////////////////////////////////////////////////////////////
		// making the final image(s)
		var w = 512;
		var h = 512;
		var packed = packer.Pack.pack(boxes, { width: w, height: h, padding: options.padding });
		for (b in packed) {
			var f = frames.get(b.id);
			f.x = b.x;
			f.y = b.y;
		}

		var data = haxe.io.Bytes.alloc(w * h * 4);
		for (f in frames)
			aseprite.tools.Blit.pixels(data, f.x, f.y, w, f.data, f.width, f.height);

		var imagePath = '$output.png';
		var imageName = haxe.io.Path.withoutDirectory(imagePath);
		var file = sys.io.File.write(imagePath);
		var writer = new format.png.Writer(file);
		writer.write(format.png.Tools.build32ARGB(w, h, data));

		var sprites : Array<SpritesheetDef> = [{
			image: imageName,
			width: w,
			height: h,
			imageFormat: "RGBA8888",
			frames: frames,
		}];

		//////////////////////////////////////////////////////////////
		// creating the metadata
		switch(options.format) {
			case Atlas:
				for (shd in sprites) {
					var content = aseprite.metadata.Atlas.make(shd);
					sys.io.File.saveContent('$output.atlas', content);
				}
		}
	}
}
