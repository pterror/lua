#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

require("lib.http.server").server(
	function () end,
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	tonumber(arg[1] or os.getenv("PORT") or os.getenv("port") or 8080)
)
