local ffi = require("ffi")

local mod = {}

if ffi.os == "Windows" then error("get_environ: windows not supported") end
ffi.cdef [[ char **get_environ(); ]]
--[[@type { get_environ: fun(): string[] }]]
local env_ffi = ffi.load(debug.getinfo(1).source:match("@?(.*/)") .. "get_environ.so")

local ptr = env_ffi.get_environ()

local get_environ_iter = function (_, i)
	local str = ptr[i + 1]
	if str == nil then return end
	return i + 1, ffi.string(str)
end

-- thinnest possible wrapper over `environ`
mod.get_environ = function ()
	return get_environ_iter, nil, -1
end

return mod
