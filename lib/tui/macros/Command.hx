package tui.macros;

using tui.macros.Helpers;

import haxe.macro.Expr;
import haxe.macro.Context;

class Command {

	public static function defaults() : Array<Field> {
		var fields = Context.getBuildFields();

		if (!fields.hasField("name")) fields.push({
			name : "name",
			access : [ APublic ],
			kind : FVar(macro : String, macro $v{Context.getLocalClass().get().name.toLowerCase()}),
			pos : Context.currentPos(),
		});

		if (!fields.hasField("manDescription")) fields.push({
			name : "manDescription",
			access : [ APublic ],
			kind : fields.getField("description").kind,
			pos : Context.currentPos(),
		});

		if (!fields.hasField("hidden")) fields.push({
			name : "hidden",
			access : [ APublic ],
			kind : FVar(macro : Bool, macro $v{false}),
			pos : Context.currentPos(),
		});

		if (!fields.hasField("display")) fields.push({
			name : "display",
			access : [ APublic ],
			kind : FVar(macro : Null<String>, macro $v{null}),
			pos : Context.currentPos(),
		});

		if (!fields.hasField("switches")) fields.push({
			name : "switches",
			access : [ APublic ],
			kind : FVar(macro : Array<tui.types.Switch>, macro $v{[]}),
			pos : Context.currentPos(),
		});

		if (!fields.hasField("commands")) fields.push({
			name : "commands",
			access : [ APublic ],
			kind : FVar(macro : Array<tui.types.Command>, macro $v{[]}),
			pos : Context.currentPos(),
		});

		if(!fields.hasField("new")) fields.push({
			name : "new",
			access : [ APublic ],
			pos : Context.currentPos(),
			kind : FFun({
				args : [ ],
				expr: macro { },
			}),
		});

		if(!fields.hasField("check")) fields.push({
			name : "check",
			access : [ APublic ],
			pos : Context.currentPos(),
			kind : FFun({
				args : [ { name : "param", type : macro : String }],
				ret : macro : Bool,
				expr : macro {
					return param == name;
				}
			}),
		});

		return fields;
	}

}
