local mod = {}

--[[themes will be ignored - for better terminal output use a tui instead]]
local keybinds = "qwertyuiopasdfghjklzxcvbnm"
local list_keybinds = "1234567890" .. keybinds
local list_keybind_length = #list_keybinds - 1

local renderers = {}
local render = function (node, write)
  local renderer = renderers[node.type]
  if not renderer then io.stderr:write("unknown node type: ", node.type) return end
  renderer(node, write)
end
renderers.list = function (node, write)
  for i = 1, math.min(#node.items, list_keybind_length) do
    write("[")
    write(list_keybinds:sub(i, i))
    write("] ")
    render(node.items[i], write)
  end
end
mod.renderers = renderers


return mod
