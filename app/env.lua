#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local get_environ_stateless = require("dep.get_environ").get_environ_stateless

for _, e in get_environ_stateless() do print(e) end
