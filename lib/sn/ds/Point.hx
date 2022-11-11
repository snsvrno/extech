package sn.ds;

private typedef Point_ = {x:Float,y:Float};

@:forward(x,y)
abstract Point(Point_) to Point_ {

	inline public function new(?x:Float = 0, ?y:Float = 0) this = {x:x,y:y};

	inline public static function fromObject(o : h2d.Object) : Point {
		return new Point(o.x, o.y);
	}

	inline public static function fromCamera(o : h2d.Camera) : Point {
		return new Point(o.x, o.y);
	}
}
