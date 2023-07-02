#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local files = {}
for i = 1, #arg do
	files[#files+1] = io.open(arg[i])
end

while #files > 0 do
	local byte = 0
	local i = 1
	while i <= #files do
		local b = files[i]:read(1)
		if not b then table.remove(files, i)
		else
			byte = bit.bxor(b:byte(1), byte)
			i = i + 1
		end
	end
	if #files > 0 then io.stdout:write(string.char(byte)) end
end
