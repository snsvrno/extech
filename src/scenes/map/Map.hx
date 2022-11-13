package scenes.map;

using scenes.map.Mode;

class Map extends gamekit.Scene {

	private var mode(default,set) : Mode;
	private function set_mode(newMode : Mode) : Mode {
		grid.gridColor = newMode.getColor();
		return mode = newMode;
	}

	var grid : Grid;

	override function init() {

		///////////////////////////////////////////////////////////
/*
		var filters = new h2d.filter.Group();

		var bubble = new shaders.Bubble();
		var bubbleFilter = new h2d.filter.Shader(bubble);
		filters.add(bubbleFilter);
		
		var crt = new shaders.CRT();
		var crtFilter = new h2d.filter.Shader(crt);
		filters.add(crtFilter);

		s2d.filter = filters;
*/
		//////////////////////////////////////////////////////////

		s2d.camera.setAnchor(0.5, 0.5);
		grid = new Grid(s2d.camera, s2d);

		//////////////////////////////////////////////////////////
		mode = Navigation;

		#if debug debug.Debug.attach(ui); #end
	}

	override function update(dt : Float) {
		#if debug debug.Debug.update(dt); #end
		grid.update(dt);
	}

	////////////////////////////////////////////////////////////

	inline static private var zoomIncrement : Float = 0.1;
	inline static private var zoomMin : Float = 0.2;
	inline static private var zoomMax : Float = 2;
	private function zoom(delta : Float) {
		var newScale = s2d.camera.scaleX + zoomIncrement * delta;
		if (newScale > zoomMax) newScale = zoomMax;
		else if (newScale < zoomMin) newScale = zoomMin;
		s2d.camera.setScale(newScale, newScale);
	}

	////////////////////////////////////////////////////////////

	override function onMouseClick(x:Float, y:Float, button:Int) switch(mode) {
		case Navigation:
			mode = NavigationDrag(sn.ds.Point.fromCamera(s2d.camera), new sn.ds.Point(ui.mouseX,ui.mouseY));

		case NavigationDrag(_,_):
			// nothing
	}

	override function onMouseRelease(x:Float, y:Float, button:Int) switch(mode) {
		case NavigationDrag(_,_):
			mode = Navigation;

		case Navigation:
			// nothing
	}

	override function onMouseWheel(delta:Float) switch(mode) {
		case Navigation:
			zoom(delta);

		case NavigationDrag(_,_):
			// nothing
	}

	override function onMouseMove(x:Float, y:Float) {
		debug.Debug.updateWatch("pos", '${x},${y}');

		switch(mode) {
			case NavigationDrag(cpos,startpos):
				s2d.camera.x = cpos.x - (ui.mouseX - startpos.x) / s2d.camera.scaleX;
				s2d.camera.y = cpos.y - (ui.mouseY - startpos.y) / s2d.camera.scaleY;

			case Navigation:
				// nothing
		}
	}

	////////////////////////////////////////////////////////////
}
