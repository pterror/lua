#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ffi = require("ffi")

local readelf_file = io.popen("readelf -d " .. arg[1]:gsub("'", "\\'"))
local readelf_lines = readelf_file:read("*all")
readelf_file:close()

ffi.cdef [[
  void *dlopen(const char *filename, int flags);
  char *dlerror(void);
]]

for dep in readelf_lines:gmatch("Shared library: %[(.-)%]") do
  local result = ffi.C.dlopen(dep, 2 --[[RTLD_NOW]])
  if result ~= nil then print("OK " .. dep)
  else print("NO " .. dep); print("ER " .. tostring(ffi.C.dlerror())) end
end
