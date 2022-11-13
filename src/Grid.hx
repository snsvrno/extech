using gamekit.tools.CameraTools;

import sn.ds.Color;

/**
	* the background map/grid controller class
	*/
class Grid extends h2d.Object {

	/** the painting color of the grid */
	public var gridColor(default, set) : Color;
	private function set_gridColor(newColor : Color) : Color {
		backBuffer.color = grid.color = newColor.toVec();
		return gridColor = newColor;
	}

	private var grid : h2d.TileGroup;
	private var backBuffer : h2d.TileGroup;

	/** reference back to the main view camera */
	private var camera : h2d.Camera;

	/** the world space that the grid covers */
	private var area : gamekit.ds.Window = {x:0,y:0,h:0,w:0};

	/**
		* creates a new grid
		*
		* @param camera : h2d.Camera the main viewport camera
		* @param parent : h2d.Object
		*/
	public function new(camera : h2d.Camera, ?parent : h2d.Object) {
		super(parent);

		var gridTile = hxd.Res.spritesheet.get('grid');

		grid = new h2d.TileGroup(gridTile, this);
		grid.alpha = Settings.grid.alpha;

		backBuffer = new h2d.TileGroup(gridTile, this);
		backBuffer.alpha = 0;
		if (Settings.grid.backbuffer == false) backBuffer.remove();

		this.camera = camera;
		redraw() ;
	}

	/**
		* clears all the tiles and replaces them to completely
		* fill the viewport of the camera
		*/
	public function redraw() {

		// we will only use the backbuffer is the scale of the grid
		// has changed
		if (hasDifferentScale() && Settings.grid.fade.enabled) {

			////////////////////////////////////////////////////////////
			// set up the back buffer fade
			backBuffer.setScale(grid.scaleX);
			backBuffer.alpha = Settings.grid.alpha;
			// we add the transition effect to the update queue
			{
				var timer = 0.0;
				var limit = Settings.grid.fade.timer;
				gamekit.Game.addToUpdateCalls((dt) -> {
					timer += dt;
					if (timer >= limit) {
						backBuffer.alpha = 0;
						return true;
					} else {
						backBuffer.alpha = Settings.grid.alpha * (1 - timer/limit);
						return false;
					}
				});
			}

			//////////////////////////////////////////////////////////
			// set up the grid fade
			grid.alpha = 0;
			// we add the transition effect to the update queue
			{
				var timer = 0.0;
				var limit = Settings.grid.fade.timer;
				gamekit.Game.addToUpdateCalls((dt) -> {
					timer += dt;
					if (timer >= limit) {
						grid.alpha = Settings.grid.alpha;
						return true;
					} else {
						grid.alpha = Settings.grid.alpha * (timer/limit);
						return false;
					}
				});
			}
		}

		redrawTiles(grid);
		redrawTiles(backBuffer, backBuffer.scaleX, false);
	}

	/**
		* clears and redraws the tile batch for the grid
		*
		* @param batch : h2d.TileGroup the set to draw, either the `grid` or `backbuffer`
		* @param scale : Float optional scale for the batch
		* @param setArea : Bool optional switch to then set the visible area with the resulting batch
		*/
	private function redrawTiles(batch : h2d.TileGroup, ?scale : Float, ?setArea : Bool = true) {
		batch.clear();

		var drawScale = if (scale != null) scale else calculateScale();

		var window = camera.getViewport();
		var startx = (Math.floor(window.x / drawScale / batch.tile.width)) * batch.tile.width;
		var starty = (Math.floor(window.y / drawScale / batch.tile.height)) * batch.tile.height;

		batch.setScale(drawScale);

		var width = Math.ceil(window.w / drawScale / batch.tile.width) + 1;
		var height = Math.ceil(window.h / drawScale / batch.tile.height) + 1;
		var count = 0;
		for (i in 0 ... width) for (j in 0 ... height) {
			batch.add(startx + i * batch.tile.width, starty + j * batch.tile.height, batch.tile);
			count += 1;
		}

		// optionally sets the visible area that is used in redraw calculations
		if (setArea) {
			area.h = height * batch.tile.height * drawScale;
			area.w = width * batch.tile.width * drawScale;
			area.x = startx + width * batch.tile.width / 2 - width * batch.tile.width * drawScale / 2;
			area.y = starty + height * batch.tile.height / 2 - height * batch.tile.height * drawScale / 2;
		}
	}

	/**
		* checks the display area vs the camera viewport
		* and determines if the grid needs to
		* be updated
		*/
	public function update(dt : Float) {
		var viewport = camera.getViewport();

		if ( isOutsideViewport(viewport) || hasDifferentScale() ) redraw();
	}

	/**
		* calculates what the view scale should be based on the camera scale
		*/
	private function calculateScale() : Float {
		var factor = Math.floor(camera.scaleX/0.25);

		var drawScale = 1.0;
		if (camera.scaleX < 1) drawScale = 4 - factor;
		else if (camera.scaleX > 1) drawScale = 1/(factor - 3);
		return drawScale;
	}

	/////////////////////////////////////////////////////////////////////////////////
	// INLINE

	inline private function isOutsideViewport(viewport : gamekit.ds.Window) : Bool {
		return
			left(viewport) < left(area) ||
			right(viewport) > right(area) ||
			top(viewport) < top(area) ||
			bottom(viewport) > bottom(area);
	}

	inline private function left(window: gamekit.ds.Window) : Float return window.x;
	inline private function right(window: gamekit.ds.Window) : Float return window.x + window.w;
	inline private function top(window: gamekit.ds.Window) : Float return window.y;
	inline private function bottom(window: gamekit.ds.Window) : Float return window.y + window.h;

	/**
		* checks if the scale has chonged enough to warrent a redraw
		*/
	inline private function hasDifferentScale() : Bool {
		return calculateScale() != grid.scaleX;
	}
}
