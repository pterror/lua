#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

if not arg[1] then for _, e in require("dep.env").env_stateless() do print(e) end
else
  local pattern = "^" .. arg[1] .. "=(.+)"
  for _, e in require("dep.env").env_stateless() do
    local m = e:match(pattern)
    if m then print(m); return end
  end
end
