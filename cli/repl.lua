#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: lowercase-global]]

local epoll = require("dep.epoll").new()
--[[@type fun(...: any)]]
print = require("dep.pretty_print").pretty_print

local co

input = function (prompt)
	io.stdout:write(prompt or "> ")
	io.stdout:flush()
	return coroutine.yield()
end

io.stdout:write("$ ")
io.stdout:flush()
--[[@diagnostic disable-next-line: param-type-mismatch]]
epoll:add(0, function (data)
	if co == nil then
		local fn, err = loadstring(data:byte(1) == 0x3b --[[;]] and data:sub(2) or ("return " .. data))
		if fn then
			co = coroutine.create(fn)
			local __, ret = coroutine.resume(co)
			_ = ret
			if ret then print(ret) end
		else io.stderr:write("error:\n", err or "", "\n") end
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
		io.stderr:write(err, "\n")
		io.stdout:write("$ ")
		io.stdout:flush()
	end
end
