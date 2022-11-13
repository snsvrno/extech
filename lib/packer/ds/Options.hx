package packer.ds;

typedef Options = {
	?method : PackingMethod,
	?padding : Int,
	?height : Int,
	?width : Int,
};

function defaults(options : Options) {
	if (options.method == null) options.method = Simple;
	if (options.padding == null) options.padding = 2;
	if (options.height == null) options.height = 512;
	if (options.width == null) options.width = 512;
}
