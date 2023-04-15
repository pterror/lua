#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable: lowercase-global]]

local epoll = require("dep.epoll").new()
--[[@type fun(...: any)]]
print = require("dep.pretty_print").pretty_print

local co

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
		local __, ret = coroutine.resume(co, data)
		_ = ret
		if ret then print(ret) end
	end
	if co and coroutine.status(co) == "dead" then
		co = nil
		io.stdout:write("> ")
		io.stdout:flush()
	end
end)

local resume = function (...)
	local __, ret = coroutine.resume(co, ...)
	_ = ret
	if ret then print(ret) end
	if co and coroutine.status(co) == "dead" then
		co = nil
		io.stdout:write("> ")
		io.stdout:flush()
	end
end

input = function (prompt)
	io.stdout:write(prompt or "> ")
	io.stdout:flush()
	return coroutine.yield()
end

sh_ = io.popen
sh = function (cmd) return io.popen(cmd):read("*all") end

local lazy_load_table = {
	f = { "lib.it_fn" },
	it = { "lib.it_fn", "it" },
	a = { "lib.functional.array", "array" },
	dig = { "lib.dns.tcp_client", "client", function (client)
		return function (domain, type)
			--[[FIXME: metatable tostring() support in pretty_print]]
			client(resume, "localhost", domain, nil, type and require("lib.dns.format").type[type], nil, epoll)
			return coroutine.yield()
		end
	end },
}

local rawget = rawget
--[[@diagnostic disable-next-line: param-type-mismatch]]
setfenv(0, setmetatable(_G, {
	__index = function (self, key)
		local val = rawget(self, key)
		if val then return val end
		local lazy_load = lazy_load_table[key]
		if lazy_load then
			val = require(lazy_load[1])
			for i = 2, #lazy_load do
				if not val then break end
				local key2 = lazy_load[i]
				val = type(key2) == "function" and key2(val) or val[key2]
			end
			self[key] = val
			lazy_load_table[key] = nil
		end
		return rawget(self, key)
	end,
}))

--[[TODO: iterator based file stuff, buffer with limited history]]
--[[i wanted something else but forgot]]

io.stdout:write("> ")
io.stdout:flush()

while true do
	local success, err = xpcall(epoll.loop, debug.traceback, epoll)
	if not success and err then
		if err:match("^.+: interrupted!") then return end
		print(err)
		io.stdout:write("> ")
		io.stdout:flush()
	end
end
