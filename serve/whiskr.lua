#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[@diagnostic disable-next-line: param-type-mismatch]]
local root = arg[1] or require("lib.path").resolve(os.getenv("HOME"), "whiskr.db")

local here = debug.getinfo(1).source:match("@?(.*[/\\])")
local sep = here:find("/") and "/" or "\\"
local index_html = here .. "static" .. sep .. "whiskr.html"

--[[@type http_table_handler]]
local routes = {
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	api = require("serve_api.whiskr").make_routes(root),
	[""] = function (_, res)
		local f = io.open(index_html)
		if not f then res.status = 404; return end
		res.headers["Content-Type"] = "text/html"
		res.body = f:read("*all")
		f:close()
	end
}
routes["index.html"] = routes[""]
if DEV then routes._routes = require("lib.http.router.table_list_routes").list_routes_handler(routes) end

return require("lib.http.server").server(
	require("lib.http.router.chain").chain_router(
		require("lib.http.router.tablex").table_router(routes),
		require("lib.http.router.staticx").static_router(here .. "static")
	),
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	tonumber(os.getenv("PORT") or os.getenv("port") or 8080)
)
