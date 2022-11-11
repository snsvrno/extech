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
		case Navigation | NavigationDrag(_,_): return Color.fromARGBf(1,0,0,1);
	}
}
