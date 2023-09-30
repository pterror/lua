#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local rest = function (_, ...) return ... end
package.loaders[2]("serve_api." .. arg[1])(rest(unpack(arg)))
