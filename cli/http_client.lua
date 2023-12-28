#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end


local ffi = require("ffi")
ffi.cdef [[int isatty(int fd);]]
print(require("lib.http.format").string_to_http_client_response(assert(require("lib.http.client").send({
  --[[@diagnostic disable-next-line: assign-type-mismatch]]
  method = arg[1], host = arg[2], path = arg[3] or "/", port = tonumber(arg[4]), body = ffi.C.isatty(0) ~= 0 and "" or io.read("*all"),
  headers = {},
}))).body)
