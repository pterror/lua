local ffi = require("ffi")

local mod = {}

if ffi.os == "Windows" then error("get_environ: windows not supported") end
ffi.cdef [[ char **get_environ(); ]]
--[[@type { get_environ: fun(): string_c[] }]]
local env_ffi = ffi.load(debug.getinfo(1).source:match("@?(.*/)") .. "get_environ.so")

local ptr = env_ffi.get_environ()

local get_environ_iter = function (_, i)
	local str = ptr[i + 1]
	if str == nil then return end
	return i + 1, ffi.string(str)
end

--[[thinnest possible wrapper over `get_environ`]]
mod.get_environ_stateless = function ()	return get_environ_iter, nil, -1 end

mod.get_environ = function ()
	local env = {}
	while true do
		local str = ptr[0]
		if str == nil then break end
		ptr = ptr + 1
		local name, value = ffi.string(str):match("(.-)=(.+)")
		env[name] = value
	end
	return env
end

return mod
