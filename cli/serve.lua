#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

--[[FIXME: also fix serve_dev, serve_api and serve_api_dev to work with new repo structure]]

local render = require("lib.ui.html").render

local rest = function (_, ...) return ... end
local api = require("api." .. arg[1]).api(rest(unpack(arg)))
local success, app = xpcall(package.loaders[2]("app." .. arg[1]), debug.traceback)
local parts = {} --[[@type string[] ]]
local write = function (text) parts[#parts+1] = text end --[[@param text string]]
render(app, write)
local index_html = table.concat(parts)
--[[@diagnostic disable-next-line: cast-local-type]]
parts = nil
local api_router = require("lib.http.router.api").router(api)
require("lib.http.server").server(function (req, res)
  if req.path == "/" then res.body = index_html; return end
  if req.path:sub(1, 5) == "/api/" then
    req.path = req.path:sub(6); api_router(req, res); return
  end
end)