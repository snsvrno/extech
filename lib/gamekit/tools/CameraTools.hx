package gamekit.tools;

class CameraTools {

	public static function getViewport(camera : h2d.Camera) : gamekit.ds.Window {
		var w = camera.viewportWidth / camera.scaleX;
		var h = camera.viewportHeight / camera.scaleY;

		var x = camera.x - w/2;
		var y = camera.y - h/2;
		return { x:x, y:y, h:h, w:w }
	}
}
