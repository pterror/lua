#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ext_mimetype = require("lib.mimetype.by_name").mimetype
local path = require("lib.path")

local base_path = arg[1] or "."
local static, err = require("lib.http.router.static").router(base_path)
assert(static, err)

require("lib.http.server").server(function (req, res)
	if req.path:match(".lua$") then res.status = 404
	else static(req, res) end
	if res.status == 404 then
		local _, str = pcall(dofile, path.resolve(base_path, req.path .. ".lua"), "t")
		if str then
			res.status = 200
			res.headers["Content-Type"] = "text/html"
			res.body = str
			return
		end
	end
	res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(req.path)
	--[[@diagnostic disable-next-line: param-type-mismatch]]
end, tonumber(arg[2] or os.getenv("port") or os.getenv("PORT")))
