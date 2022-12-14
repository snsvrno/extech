package sn.ds;

// https://code.haxe.org/category/abstract-types/color.html

/**
 * ARGB color type based on a 32-bit integer.
 */
abstract Color(Int) from Int to Int {
	/**
	 * Performs implicit casting from an ARGB hex string to a color.
	 * @param arg ARGB hex string
	 * @return Color based on hex string
	 */
	@:from public static inline function fromString(argb : String) : Color {
		return new Color(Std.parseInt(argb));
	}

	/**
	 * Creates a new color from integer color components.
	 * @param a Alpha channel value
	 * @param r Red channel value
	 * @param g Green channel value
	 * @param b Blue channel value
	 * @return	Color based on color components
	 */
	public static inline function fromARGBi(a : Int, r : Int, g : Int, b : Int) : Color {
		return new Color((a << 24) | (r << 16) | (g << 8) | b);
	}
	
	/**
	 * Creates a new color from floating point color components.
	 * @param a Alpha channel value
	 * @param r Red channel value
	 * @param g Green channel value
	 * @param b Blue channel value
	 * @return	Color based on color components
	 */
	public static inline function fromARGBf(a : Float, r : Float, g : Float, b : Float) : Color {
		return fromARGBi(Std.int(a * 255), Std.int(r * 255), Std.int(g * 255), Std.int(b * 255));
	}

	#if heaps
	public  inline function toVec() : h3d.Vector {
		return h3d.Vector.fromColor(this);
	}
	#end

	/**
	 * Constructs a new color.
	 * @param	 argb	Color formatted as ARGB integer
	 */
	inline public function new(argb : Int) this = argb;
	
	/**
	 * Integer color channel getters and setters.
	 */

	public var ai(get, set) : Int;
	inline function get_ai() return (this >> 24) & 0xff;
	inline function set_ai(ai : Int) { this = fromARGBi(ai, ri, gi, bi); return ai; }
	
	public var ri(get, set) : Int;
	inline function get_ri() return (this >> 16) & 0xff;
	inline function set_ri(ri : Int) { this = fromARGBi(ai, ri, gi, bi); return ri; }
	
	public var gi(get, set) : Int;
	inline function get_gi() return (this >> 8) & 0xff;
	inline function set_gi(gi : Int) { this = fromARGBi(ai, ri, gi, bi); return gi; }
	
	public var bi(get, set) : Int;
	inline function get_bi() return this & 0xff;
	inline function set_bi(bi : Int) { this = fromARGBi(ai, ri, gi, bi); return bi; }
	
	/**
	 * Floating point color channel getters and setters.
	 */

	public var af(get, set) : Float;
	inline function get_af() return ai / 255;
	inline function set_af(af : Float) { this = fromARGBf(af, rf, gf, bf); return af; }
	
	public var rf(get, set) : Float;
	inline function get_rf() return ri / 255;
	inline function set_rf(rf : Float) { this = fromARGBf(af, rf, gf, bf); return rf; }
	
	public var gf(get, set) : Float;
	inline function get_gf() return gi / 255;
	inline function set_gf(gf : Float) { this = fromARGBf(af, rf, gf, bf); return gf; }
	
	public var bf(get, set) : Float;
	inline function get_bf() return bi / 255;
	inline function set_bf(bf : Float) { this = fromARGBf(af, rf, gf, bf); return bf; }

}
