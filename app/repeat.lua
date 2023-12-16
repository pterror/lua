#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local times = assert(tonumber(arg[1]), "first argument should be a number")
local parts = {} --[[@type string[] ]]
for i = 2, #arg do
  local part = tostring(arg[i])
  if part:find("'") then parts[#parts+1] = "\"" .. arg[i] .. "\""
  else parts[#parts+1] = "'" .. arg[i] .. "'" end
end
local cmd = table.concat(parts, " ")
for i = 1, times do
  local suc, _, status = os.execute(cmd)
  if not suc then io.stderr:write("failed on try " .. i .. "/" .. times); os.exit(status) end
end
