package packer.ds;

typedef Box = {

	/** something to tie this back to the source box */
	id : String,

	w : Int,
	h : Int,

	/** used to keep related images / boxes together */
	?parent : String,
}
