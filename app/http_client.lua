#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local send = require("lib.http.client").send
local http = require("lib.http.format")

print(http.string_to_http_client_response(assert(send({
  --[[@diagnostic disable-next-line: assign-type-mismatch]]
  method = arg[1], host = arg[2], path = arg[3] or "/", port = tonumber(arg[4]), body = io.read("*all"),
  headers = {},
}))).body)
