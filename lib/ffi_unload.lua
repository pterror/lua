local ffi = require("ffi")

local mod = {}

if ffi.os ~= "Linux" then
	error("ffi_unload: currently only Linux is supported")
end

ffi.cdef [[
	int dlclose(void *handle);
]]

--[[@param lib ffi.namespace*]]
mod.unload = function (lib)
	return ffi.C.dlclose(ffi.cast("void **", lib)[0]) == 0
end

return mod
