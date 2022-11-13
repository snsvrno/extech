package scenes.map;

import sn.ds.Point;
import sn.ds.Color;

enum Mode {
	// moving around the map / the world
	Navigation;
	NavigationDrag(camera:Point, mouse:Point);
}

function getColor(mode : Mode) : Int {
	switch (mode) {
		case Navigation: return new Color(Settings.grid.mode.navigation);
		case NavigationDrag(_,_): return new Color(Settings.grid.mode.navigation_drag);
	}
}
