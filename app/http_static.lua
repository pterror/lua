#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ext_mimetype = require("lib.mimetype.by_name").mimetype
local static, err = require("lib.http.router.staticx").static_router(arg[1] or ".")
assert(static, err)

require("lib.http.server").server(function (req, res)
	static(req, res)
	res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(req.path)
	--[[@diagnostic disable-next-line: param-type-mismatch]]
end, tonumber(arg[2] or os.getenv("port") or os.getenv("PORT") or 8080))
