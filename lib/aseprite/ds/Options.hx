package aseprite.ds;

typedef Options = {
	?format : Metadata,
	?padding : Int,
};

function defaults(options : Options) {
	if (options.format == null) options.format = Atlas;
	if (options.padding == null) options.padding = 2;
}
