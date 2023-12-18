#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local epoll = require("dep.epoll").new()
local json = require("dep.lunajson")

--[[@type (fun(msg: websocket_message))?]]
local send

require("lib.http.serverx").server({
	ws = function (_, msg) print(json.value_to_json(msg)) end,
	ws_open = function (_, send_) io.stderr:write("[info] socket connected\n"); send = send_ end,
	ws_close = function () io.stderr:write("[info] socket disconnected\n"); send = nil end,
	--[[@diagnostic disable-next-line: param-type-mismatch]]
}, tonumber(arg[1] or os.getenv("PORT") or os.getenv("port")), epoll)

--[[@diagnostic disable-next-line: param-type-mismatch]]
epoll:add(0, function (data)
  if not send then io.stderr:write("[error] socket not connected\n") return end
  local success, value = pcall(json.json_to_value, data)
  if not success then io.stderr:write("[error] could not parse json: ", json.value_to_json(value), "\n"); return end
  send(value)
end, nil)

epoll:loop()
