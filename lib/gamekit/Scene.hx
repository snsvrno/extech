package gamekit;

class Scene {
	private var initialized : Bool = false;

	public var s2d : h2d.Scene;
	public var ui : h2d.Scene;

	public var name : String;
	public var id : String;

	public function new() {
		s2d = new h2d.Scene();
		ui = new h2d.Scene();
		id = sn.Hash.gen(10);
	}

	final public function setup() : Bool {
		if (initialized) return false;
		else initialized = true;

		s2d.addEventListener(eventHandler);
		init();

		return true;
	}

	/**
	 * called once, the first time this scene is set
	 */
	public function init() {

	}

	/**
	 * is called on every update while this loop is
	 * currently loaded. is not called unless it is on
	 * the top of the stack
	 */
	public function update(dt : Float) {
	
	}

	/**
	 * is called once when the scene is set as the active scene
	 * as long as it has already been initialized. it will not
	 * be called along with `init()`
	 */
	public function onSet() {

	}

	final private function eventHandler(e : hxd.Event) {
		switch(e.kind) {
			case EPush: onMouseClick(e.relX, e.relY, e.button);
			case EMove: onMouseMove(e.relX, e.relY);
			case ERelease: onMouseRelease(e.relX, e.relY, e.button);
			case EKeyDown: onKeyPressed(e.keyCode);
			case EKeyUp: onKeyReleased(e.keyCode);
			case EWheel: onMouseWheel(e.wheelDelta);
			case _:
		}
	}

	public function onMouseWheel(delta:Float) { }
	public function onMouseClick(x:Float, y:Float, button:Int) { }
	public function onMouseMove(x:Float, y:Float) { }
	public function onMouseRelease(x:Float, y:Float, button:Int) { }
	public function onKeyPressed(key:Int) { }
	public function onKeyReleased(key:Int) { }

	public function onResize(w:Int, h:Int) { }

	/**
	 * is called once when the scene is being unset as the active
	 * scene
	 */
	public function onUnset() {

	}

	final private function s2dToUi(p : h2d.col.Point) {
		p.x = p.x - (s2d.camera.x - (s2d.camera.anchorX * s2d.camera.viewportWidth)) / s2d.camera.scaleX;
		p.y = p.y - (s2d.camera.y - (s2d.camera.anchorY * s2d.camera.viewportHeight)) / s2d.camera.scaleY;
		trace(p.x, p.y);
	}

}
