#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local epoll = require("dep.epoll").new()
local client = require("lib.tcp.client").client

local color = os.getenv("color") == "1"

if color then io.write("\x1b[1;96m"); io.flush() end
--[[@diagnostic disable-next-line: param-type-mismatch]]
local write = client(arg[1], tonumber(arg[2]), color and function (data)
  io.write("\x1b[0m", data, "\x1b[1;96m"); io.flush()
end or io.write, epoll)
--[[@diagnostic disable-next-line: param-type-mismatch]]
epoll:add(0, write, nil, true)
local success, err = xpcall(epoll.loop, debug.traceback, epoll)
if not success and err then
  if err:match("^.+: interrupted!") then return end
  io.stderr:write(err, "\n")
  os.exit(1)
end
