package gamekit;

class Game extends hxd.App {

	// STATIC ACCESS MEMBERS /////////////////////////////////////////////////////////////

	private static var instance : Game;

	public static function addToUpdateCalls(call : gamekit.ds.UpdateCall)
		if (instance != null) instance.temporaryUpdateCalls.push(call);

	// PRIVATE CLASS MEMBERS /////////////////////////////////////////////////////////////

	private var resolution(default,set) : gamekit.ds.Resolution;
	private function set_resolution(newResolution : gamekit.ds.Resolution) : gamekit.ds.Resolution {
		resolution = newResolution;
		setResolution();
		return resolution;
	}

	private var uiResolution(default,set) : gamekit.ds.UiResolution = SameAsS2d;
	private function set_uiResolution(newResolution : gamekit.ds.UiResolution) : gamekit.ds.UiResolution {
		uiResolution = newResolution;
		setResolution();
		return uiResolution;
	}

	/**
		* stack of scenes
		*/
	private var stack : Array<Scene> = [];

	private var temporaryUpdateCalls : Array<gamekit.ds.UpdateCall> = [];

	// PUBLIC CLASS MEMBERS /////////////////////////////////////////////////////////////

	/**
	 * is the currently active scene,
	 * can be null if there is no active scene
	 */
	public var scene(get, set) : Null<Scene>;
	private function get_scene() : Null<Scene> {
		var i = stack.length;
		if (i > 0) return stack[i-1];
		else return null;
	}
	private function set_scene(newScene : Null<Scene>) : Null<Scene> {
		// clean up the connections to the old scene.
		if (scene != null) cleanupScene(scene);

		// set the new scene, but if it already exists remove it.
		// and place it on the top of the stack.
		if (stack.indexOf(newScene) >= 0) stack.remove(newScene);
		stack.push(newScene);

		// connect the new scene.
		if (newScene != null) setupScene(newScene);

		return scene;
	}

	////////////////////////////////////////////////////////////////////////////////////

	public function new() {
		super();
		instance = this;
	}

	override function render(e : h3d.Engine) {
		var s = scene;
		if (s != null) {
			s.s2d.render(e);
			s.ui.render(e);
		}
	}

	// primarily copied from hxd.App's setup with all the scene
	// stuff removed, because it is initalized in its own `new`
	// function and in `scene` set function.
	override function setup() {
		var initDone = false;
		engine.onReady = hxd.App.staticHandler;
		engine.onResized = function() {
			if (onResized() == false) return;
			if(initDone) onResize();
		}
		sevents = new hxd.SceneEvents();
		loadAssets(function() {
			initDone = true;
			init();
			hxd.Timer.skip();
			mainLoop();
			hxd.System.setLoop(mainLoop);
			hxd.Key.initialize();
		});
	}

	private function onResized() : Bool {
		var s = scene;
		if (s == null) return false;

		s.s2d.checkResize();
		s.ui.checkResize();

		var w = hxd.Window.getInstance();
		s.onResize(w.width, w.height);

		return true;
	}

	// edit of the hxd.App mainLoop function to look at
	// the current scene in the stack.
	override function mainLoop() {
		hxd.Timer.update();
		sevents.checkEvents();
		if(isDisposed) return;
		// the main app update loop
		update(hxd.Timer.dt);
		// any temporary updates
		temporaryUpdate(hxd.Timer.dt);
		if(isDisposed) return;
		var dt = hxd.Timer.dt;
		// runs the update on the laoded scene.
		var s = scene;
		if (scene != null) {
			s.ui.setElapsedTime(dt);
			s.s2d.setElapsedTime(dt);
			s.update(dt);
		}
		
		engine.render(this);
	}

	final private function temporaryUpdate(dt : Float) {
		for (i in 0 ... temporaryUpdateCalls.length) {
			var call = temporaryUpdateCalls[temporaryUpdateCalls.length-1-i];
			if (call(dt)) temporaryUpdateCalls.remove(call);
		}
	}

	private function setupScene(s : Scene) {
		sevents.addScene(s.s2d);
		sevents.addScene(s.ui, 0);
		setResolution();

		// if the set has already been setup then we
		// call the onset callback
		if (s.setup() == false) s.onSet();
	}

	private function cleanupScene(s : Scene) {
		s.onUnset();
		sevents.removeScene(s.s2d);
		sevents.removeScene(s.ui);
	}

	private function setResolution() {
		// BUG: this doesn't seem to work, issue 0008
		return
		if (resolution == null || scene == null) return;

		scene.s2d.scaleMode = LetterBox(resolution.width, resolution.height);
		scene.s2d.camera.clipViewport = true;

		switch (uiResolution) {
			case SameAsS2d:
				scene.ui.scaleMode = scene.s2d.scaleMode;
				scene.ui.camera.clipViewport = true;

			case _:
				throw 'ui resolution mode $uiResolution is not implemented';
		}
	}

}
