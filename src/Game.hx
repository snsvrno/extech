class Game extends gamekit.Game {
	public static function main() new Game();

	override function init() {
		hxd.Res.initLocal();
		resolution = { width: 256, height: 256 };
		scene = new scenes.map.Map();
	}
}
