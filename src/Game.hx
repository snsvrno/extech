class Game extends gamekit.Game {
	public static function main() new Game();

	override function init() {


		#if (debug && hl)
		// should be the development environment

		hxd.Res.initLocal();
		hxd.res.Resource.LIVE_UPDATE = true;

		Settings.loadContent(hxd.Res.settings.entry.getText());
		hxd.Res.settings.watch(() -> Settings.loadContent(hxd.Res.settings.entry.getText()));


		#end

		resolution = { width: 256, height: 256 };
		scene = new scenes.map.Map();
	}
}
