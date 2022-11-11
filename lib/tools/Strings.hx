package tools;

using StringTools;

class Strings{

	/**
		* will split the string into line, is platform agnostic and will
		* correctly split strings encoded on all platforms
		*/
	public static function lines(string : String) : Array<String> {
		var lines = string.split("\n");
		var i = lines.length-1;
		while (i >= 0) {

			if (lines[i].contains("\t")) {
				var parts = lines[i].split("\t");
				
				for (j in 0 ... parts.length)
					lines.insert(j + i, parts[j]);
			}

			i -= 1;
		}

		// suppose to remove empty elements
		i = lines.length-1;
		while(i >= 0) {
			if (lines[i].length == 0) lines.splice(i,1);
			i -= 1;
		}

		return lines;
	}

	public static function capitalize(text : String) : String {
		var s = text.split(" ");
		for (i in 0 ... s.length) s[i] = s[i].substring(0,1).toUpperCase() + s[i].substring(1).toLowerCase();
		return s.join(" ");
	}

}
