package aseprite.tools;

class Blit {
	
	/**
		* helps blit pixel data that is stored in a 1D stream.
		*/
	public static function pixels(
		des : haxe.io.Bytes, desX : Int, desY : Int, desW :  Int,
		src : haxe.io.Bytes, srcW : Int, srcH : Int
	) {

		var desPos;
		var srcPos;
		var len = srcW * 4;
		
		for (j in 0 ... srcH) {
			srcPos = j * srcW * 4;
			desPos = (j + desY) * desW * 4 + desX * 4;
			des.blit(desPos, src, srcPos, len);
		}
	}

}
