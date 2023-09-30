#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: lowercase-global]]

local epoll = require("dep.epoll").new()

local co

input = function (prompt)
	io.stdout:write(prompt or "> ")
	io.stdout:flush()
	return coroutine.yield()
end

if #arg < 1 then io.stderr:write("usage: gameloop.lua your_game_here.lua\n"); os.exit(1); return end
game = dofile(arg[1])
if not game.commands then io.stderr:write("gameloop: game is missing commands\n"); os.exit(1); return end

io.stdout:write("$ ")
io.stdout:flush()
--[[@diagnostic disable-next-line: param-type-mismatch]]
epoll:add(0, function (data)
	if co == nil then
		--[[FIXME: handle the rest of the lines (which will be prefixed by \n), one by one]]
		local command_name, args = data:match("(%S*)%s*([^\n]*)") --[[@type string, string]]
		if not command_name then return end
		local cmd = game.commands[command_name]
		if not cmd then print("error: command '" .. command_name .. "' not found")
		else
			co = coroutine.create(cmd)
			local success, result = coroutine.resume(co, args)
			if success then if result then print(result) end
			else print("error:", result) end
		end
	else
		local __, ret = coroutine.resume(co, data:sub(1, -2))
		_ = ret
		if ret then print(ret) end
	end
	if co and coroutine.status(co) == "dead" then
		co = nil
		io.stdout:write("$ ")
		io.stdout:flush()
	end
end)

while true do
	local success, err = xpcall(epoll.wait, debug.traceback, epoll)
	if not success and err then
		if err:match("^.+: interrupted!") then return end
		print(err)
		io.stdout:write("$ ")
		io.stdout:flush()
	end
end
