--[[@diagnostic disable: duplicate-set-field]]
local c = composter
--[[TODO: switch to kitty -1 when switching away from subcompositors]]
local terminal = "kitty"
local screenshot = { "qti", "--path", os.getenv("HOME") .. "/git/qti/app/screenshot-editor/screenshot-editor.qml" }

c.hooks.on_startup = function()
	-- c.functions.exec("quickshell")
end

c.variables.terminal = terminal
c.variables.screenshot = screenshot

--[[an object literal is also ok, but assignment allows configs to be combined]]
c.keybinds["alt+q"] = function() c.functions.exec1(c.variables.terminal or terminal) end
--[[@param server composter_server]]
c.keybinds["alt+c"] = function(server) c.functions.close_focused_window(server) end
c.keybinds["alt+tab"] = function(server) c.functions.focus_next_window(server) end
--[[TODO: test]]
c.keybinds["_3270_print_screen"] = function() c.functions.exec1(c.variables.screenshot or screenshot) end
c.keybinds["alt+m"] = c.functions.exit
