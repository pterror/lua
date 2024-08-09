#!/usr/bin/env luajit
local epoll = require("dep.epoll").new()
-- TODO: chatmud client needs json (lunajson)

--- @type table<string, fun (write: fun (s: string))>
local mcp_handlers = {
	json = function (write)
	end,
}

local write
--- @diagnostic disable-next-line: param-type-mismatch
write = require("lib.tcp.client").client(arg[1], tonumber(arg[2]), require("lib.mcp.client").wrap(function (msg)
end, function (type, value)
	local fn = mcp_handlers[type]
	if fn then fn(write) end
end), epoll)
epoll:add(0, write, nil, true)
epoll:loop()