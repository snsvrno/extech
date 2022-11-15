package scenes.map;

using scenes.map.Mode;

class Map extends gamekit.Scene {

	private var mode(default,set) : Mode;
	private function set_mode(newMode : Mode) : Mode {
		grid.gridColor = newMode.getColor();
		return mode = newMode;
	}

	private var grid : Grid;

	/** the position on the zoom curve */
	private var zoomPosition : Float = 1;

	override function init() {

		name = "map";

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

		#if debug debug.Debug.attach(ui, name); #end
	}

	override function update(dt : Float) {
		#if debug debug.Debug.update(dt); #end
		grid.update(dt);
	}

	////////////////////////////////////////////////////////////

	private function zoom(delta : Float) {
		var newZoomPosition = zoomPosition - Settings.map.zoom.increment * delta;
		var newScale = Settings.map.zoom.a * Math.exp(newZoomPosition * Settings.map.zoom.b);

		if (newScale > Settings.map.zoom.max) newScale = Settings.map.zoom.max;
		else if (newScale < Settings.map.zoom.min) newScale = Settings.map.zoom.min;
		else zoomPosition = newZoomPosition;

		#if debug watch("zoom", newScale); #end
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
		#if debug watch("pos", '${x},${y}'); #end

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
