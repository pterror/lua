#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local make = require("dep.make")

local ok, tasks = pcall(dofile, "tasks.lua")
if not ok then print("error: tasks.lua not found"); return end
if not tasks.list and arg[1] == "list" then
	make.list(tasks)
else
	local ok2, err = make.make(tasks, arg[1])
	if not ok2 then io.stderr:write(err, "\n") end
end
