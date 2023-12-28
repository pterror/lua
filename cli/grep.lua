#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local pattern = arg[1] or error("grep: no pattern")

while true do
	local line = io.stdin:read("*Line")
	if not line then break end
	if line:match(pattern) then io.stdout:write(line) end
end
