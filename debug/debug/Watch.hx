package debug;

class Watch extends h2d.Flow {

	private static var primaryTile : h2d.Tile;
	private static var flashTile : h2d.Tile;

	/** will only flash if the value is actually different */
	public var onChangeOnly : Bool = true;

	var prefix : h2d.Text;
	var value : h2d.Text;

	/** used to track the changing callback, so we don't have multiple working */
	var changing : Bool = false;

	public function new(name : String, parent : h2d.Object) {
		super(parent);
		horizontalAlign = Right;
		layout = Horizontal;
		padding = 4;
		horizontalSpacing = 4;


		if (primaryTile == null) {
			primaryTile = h2d.Tile.fromColor(0xFF111111);
			flashTile = h2d.Tile.fromColor(0xFFBBBBBB);
		}
		backgroundTile = primaryTile;

		prefix = new h2d.Text(hxd.res.DefaultFont.get(), this);
		value = new h2d.Text(hxd.res.DefaultFont.get(), this);

		prefix.text = name;
		prefix.color = h3d.Vector.fromColor(0xFF666666);
	}

	public function setValue(text : String) : Null<(dt:Float) -> Bool> {
		if (value.text == text && onChangeOnly) return null;

		value.text = text;

		if (!changing) {
			var timer = 0.0;
			changing = true;
	
			// the callback function that does the "flashing"
			return function(dt : Float) {
				timer += dt;
				if (timer > Settings.debug.update_watch.flash_length) {
					backgroundTile = primaryTile;
					changing = false;
					return true;
				}

				var speed = Settings.debug.update_watch.flash_length / (Settings.debug.update_watch.flash_times + 3);
				if (Math.floor(timer / speed) % 2 == 1)
					backgroundTile = primaryTile;
				else
					backgroundTile = flashTile;

				return false;
			}
		}

		return null;
	}
}
