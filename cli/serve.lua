#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local rest = function (_, ...) return ... end
local success, err = xpcall(package.loaders[2]("serve." .. arg[1]), debug.traceback, rest(unpack(arg)))
if not success and err then
  if err:match("^.+: interrupted!") then return end
  io.stderr:write(err, "\n")
  os.exit(1)
end