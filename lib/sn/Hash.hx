package sn;

inline var MEMBERS : String = "1234567890pyfgcrlsnthdzvwmbqjkxoeuia";

class Hash {
	static public function gen(?length:Int=5) : String {
		var hash = "";
		while(hash.length < length) {
			var pos = Math.floor(Math.random() * MEMBERS.length);
			hash += MEMBERS.charAt(pos);
		}
		return hash;
	}
}
