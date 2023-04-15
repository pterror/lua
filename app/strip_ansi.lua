#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

while true do
	local line = io.stdin:read("*Line")
	if not line then break end
  io.stdout:write((line:gsub("\x1b%[(.-)m", "")))
end
