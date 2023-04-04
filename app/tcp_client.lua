#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local epoll_ = require("dep.epoll")
local client = require("lib.tcp.client").client

local epoll = epoll_.new()
--- @diagnostic disable-next-line: param-type-mismatch
local write = client(arg[1], tonumber(arg[2]), io.write, epoll)
---@diagnostic disable-next-line: param-type-mismatch
epoll:add(0, write, nil, true)
epoll:loop()
