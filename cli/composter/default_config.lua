--[[@diagnostic disable: duplicate-set-field]]
local c = composter
--[[TODO: switch to kitty -1 when switching away from subcompositors]]
local terminal = "kitty"
local screenshot = { "qti", "--path", os.getenv("HOME") .. "/git/qti/app/screenshot-editor/screenshot-editor.qml" }

--[[default values]]
c.variables.cursor_name = nil
c.variables.cursor_size_px = 24
c.variables.key_repeats_per_sec = 25
c.variables.key_repeat_delay_ms = 600
--[[@param server composter_server]]
c.hooks.on_new_toplevel = function(server) c.functions.focus_window_below_mouse(server) end
--[[@param server composter_server]]
c.hooks.on_press = function(server) end
--[[@param server composter_server]]
c.hooks.on_release = function(server) c.reset_cursor_mode(server) end
--[[@param server composter_server]]
c.hooks.on_move = function(server) c.functions.focus_window_below_mouse(server) end
c.hooks.on_startup = function() end
--[[@param server composter_server]]
c.hooks.on_exit = function(server) end

--[[custom values]]

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
