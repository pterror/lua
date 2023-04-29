#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

if not arg[1] then io.stderr:write("find: root directory needs to be given as first argument") end
local callback = assert(loadstring("return function (it) " .. (arg[2]:find("return") and "" or "return ") .. arg[2] .. " end"))()

local dir_list = require("lib.fs.dir_list").dir_list

local handle_file = function (path, name) --[[@param path string]] --[[@param name string]]
	local ret, action = callback({ type = "file", is_file = true, path = path, name = name })
	if ret then print(path) end
	if action == "stop" then os.exit(0) end
end

local handle_dir
handle_dir = function (path, name) --[[@param path string]] --[[@param name string]]
	local ret, action = callback({ type = "directory", is_dir = true, path = path, name = name })
	if ret then print(path) end
	if action == "skip" then return
	elseif action == "stop" then os.exit(0) end
	local iter, state = dir_list(path)
	if not iter then
		io.stderr:write("find: could not open directory: " .. path .. " error: " .. state .. "\n")
		return
	end
	for f in iter, state do
		if f.is_dir then handle_dir(f.path, f.name)
		else handle_file(f.path, f.name) end
	end
end

handle_dir(arg[1], arg[1]:match("[\\/](.-)[\\/]?$") or arg[1])
