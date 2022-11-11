package tui.defaults;

using tools.Strings;
using ansi.colors.ColorTools;

import ansi.Paint.paint;
import ansi.colors.Style;
import tracer.Error.error;

import tui.Formats.*;

/**
	* a standard implementation of a help command, will be
	* added to the list of commands automatically if no help
	* command is found and there is at least one command
	*/
class Help implements tui.types.Command {
	
	//////////////////////////////////////

	public var name = "help";
	public var description = "shows this screen and extended help information for each command";
	public var manDescription = "help can be used with each command to further describe the commands use and optional switches and parameters";

	private var parent : tui.types.Program;

	/////////////////////////////////////

	public function new(parent : tui.types.Program) {
		this.parent = parent;
	}

	public function run( ...args : String) {
		// get the terminal size
		var size = ansi.Command.getSize();

		// we want to know the help of the whole program.
		if (args.length == 0) {

			functionNameLine(parent.name);
			Sys.println(parent.description);
			usage(parent.name, null, parent.usageCommandOverride);
			listCommands(size.c);
			listSwitches(size.c);

		} else {
			for (comm in parent.commands) {
				if (comm.check(args[0])) {
					functionNameLine(parent.name, args[0]);
					man(comm, size.c);
					return;
				}
			}
			error("unknown command " + unknownCommand(args[0]));
		}
	}

	public function man(cmd : tui.types.Command, screenWidth : Int) {
		Sys.println(cmd.manDescription);
		usage(parent.name + " " + cmd.name, if (cmd.switches.length == 0) "" else null, "command");
		listCommands(screenWidth, cmd.commands);
		listSwitches(screenWidth, cmd.switches);
	}

	//////////////////////////////////////////////////////////////////////

	inline public function usage(cmd : String, ?switchText : String = "-s --switch", ?paramText : String = "command") {
		Sys.print("\n");
		tab();
		Sys.println(paint("Usage", White, Style.Bold) + ": " +
				command(cmd.toLowerCase()) + " " +
			  (if(switchText.length > 0) option(switchText) + " " else "") +
				parameterUsage(paramText)
			);
	}

	inline private function functionNameLine(name : String, ?cmd : String) {
		Sys.print(command(name, Style.Bold));
		if (cmd != null)
			Sys.print(" " + parameter(cmd));
		else
			Sys.print(" " + paint(parent.version, Yellow));
		Sys.print("\n");
	}

	inline private function header(text: String) {
		tab();
		Sys.println(paint(text, White, Style.Underline) + ":");
	}

	inline private function listCommands(screenWidth : Int, ?commands : Array<tui.types.Command>) {

		if (commands == null) commands = parent.commands;

		var count = 0;
		for (c in commands) if(!c.hidden) count += 1;

		// if this command has no commands then we can skip this section
		if (count > 0) {
			Sys.print("\n");
			header("Commands");

			var maxNameLength = Math.floor(Math.max(getMaxLength(commands, "display"), getMaxLength(commands, "name")));
			for (comm in commands) {
				tab(2);
				Sys.print(parameter(if (comm.display != null) comm.display else comm.name).pad(maxNameLength));

				tab();
				var pos = ansi.Command.cursorPosition();
				var lines = ansi.colors.ColorTools.splitLength(comm.description, screenWidth - pos.c + 1);
				for (i in 0 ... lines.length) {
					if (i != 0) space(pos.c - 1);
					Sys.println(lines[i]);
				}
			}
		}
	}

	inline private function listSwitches(screenWidth : Int, ?switches : Array<tui.types.Switch>) {

		if (switches == null) switches = parent.globalSwitches;

		if (switches.length > 0) {

			var groups = [];
			for (s in switches) {
				var name = if (s.group == null) "null" else s.group;
				if(!groups.contains(name)) groups.push(name);
			}

			if (groups.length > 1) {
				for(g in groups) listSwitches(screenWidth, switches.filter((a) -> {
					if(a.group == null && g == "null") return true;
					else if(a.group != null) return a.group == g;
					return false;
				}));
			}

			// if we only have one group we just do them all.
			else {
				Sys.print("\n");
				var name = groups[0].capitalize() + " ";
				if (name == "Null ") name = "";
				header(name + "Switches");

				var maxNameLength = getMaxLength(switches, "name") + 1;
				var maxSwitchLength = getMaxLength(switches, "long") + 4;

				for (gs in switches) {
					tab(2);
					Sys.print(parameter(gs.name).pad(maxNameLength));

					tab();
					var text = "";
					if (gs.short != null) text += option(gs.short);
					if (text.length > 0 && gs.long != null) text += ", ";
					if (gs.long != null) text += option(gs.long);
					if (gs.value != null && gs.value == true)
						text += " " + value(paint("<", White, Style.Dim) + "value" + paint(">", White, Style.Dim));
					Sys.print(text.pad(maxSwitchLength));

					tab();
					var pos = ansi.Command.cursorPosition();
					var lines = ansi.colors.ColorTools.splitLength(gs.description, screenWidth - pos.c + 1);
					for (i in 0 ... lines.length) {
						if (i != 0) space(pos.c - 1);
						Sys.println(lines[i]);
					}
				}
			}

		}
	}

	private function getMaxLength(a : Array<Dynamic>, param : String) : Int {
		var length = 0;
		for (item in a) {
			var value = Reflect.getProperty(item, param);
			if (value != null) {
				var l = '$value'.length;
				if (l > length) length = l;
			}
		}
		return length;
	}
}
