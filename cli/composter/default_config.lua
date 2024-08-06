--[[an object literal is also ok, but assignment allows configs to be combined]]
local c = composter
--[[TODO: switch to kitty -1 when switching away from subcompositors]]
local terminal = "kitty"
local screenshot = { "qti", "--path", os.getenv("HOME") .. "/git/qti/app/screenshot-editor/screenshot-editor.qml" }

c.variables.terminal = terminal
c.variables.screenshot = screenshot
c.keybinds["alt+q"] = function() c.functions.exec1(c.variables.terminal or terminal) end
--[[TODO: test]]
c.keybinds["_3270_print_screen"] = function() c.functions.exec1(c.variables.screenshot or screenshot) end
c.keybinds["alt+m"] = c.functions.exit
