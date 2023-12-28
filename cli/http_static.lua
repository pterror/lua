#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local root = arg[1] or "."
local ext_mimetype = require("lib.mimetype.by_name").mimetype
local static, err
if os.getenv("404") == "1" then static, err = require("lib.http.router.staticx_404").static_router(root)
else static, err = require("lib.http.router.staticx").static_router(root) end
assert(static, err)
local prefix = os.getenv("prefix")
if prefix then prefix = "/" .. prefix end

local run = function ()
	require("lib.http.server").server(prefix and function (req, res)
		if req.path:sub(1, #prefix) ~= prefix then res.status = 404; return end
		req.path = req.path:sub(#prefix + 1)
		static(req, res)
		if req.path:find(".gz$") then
			res.headers["Content-Encoding"] = "gzip"
			res.headers["Content-Length"] = ""
			res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(root .. req.path:sub(1, -3))
		else res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(root .. req.path) end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
	end or function (req, res)
		static(req, res)
		res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(root .. req.path)
		if req.path:find(".gz$") then
			res.headers["Content-Encoding"] = "gzip"
			res.headers["Content-Length"] = ""
			res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(root .. req.path:sub(1, -3))
		else res.headers["Content-Type"] = res.headers["Content-Type"] or ext_mimetype(root .. req.path) end
		--[[@diagnostic disable-next-line: param-type-mismatch]]
	end, tonumber(arg[2] or os.getenv("port") or os.getenv("PORT") or 8080))
end
local success
success, err = xpcall(run, debug.traceback)
if not success and err then
  if err:match("^.+: interrupted!") then return end
  io.stderr:write(err, "\n")
  os.exit(1)
end
