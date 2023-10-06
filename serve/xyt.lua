#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local here = debug.getinfo(1).source:match("@?(.*[/\\])")
local sep = here:find("/") and "/" or "\\"
local index_html = here .. "static" .. sep .. "xyt.html"


return require("lib.http.server").server(
	require("lib.http.router.chain").chain_router(
		function (req, res)
			if req.path ~= "/" then return false end
			local f = io.open(index_html)
			if not f then res.status = 404; return true end
			res.headers["Content-Type"] = "text/html"
			res.body = f:read("*all")
			f:close()
			return true
		end,
		require("lib.http.router.staticx").static_router(here .. "static")
	),
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	tonumber(os.getenv("PORT") or os.getenv("port") or 8080)
)
