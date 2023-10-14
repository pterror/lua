local ffi = require("ffi")

local mod = {}

if ffi.os == "Windows" then error("env: windows not supported") end
ffi.cdef [[ char **env(); ]]
--[[@type { env: fun(): string_c[] }]]
local env_ffi = ffi.load(debug.getinfo(1).source:match("@?(.*/)") .. "env.so")

local ptr = env_ffi.env()

local env_iter = function (_, i)
	local str = ptr[i + 1]
	if str == nil then return end
	return i + 1, ffi.string(str)
end

--[[thinnest possible wrapper over `env`]]
mod.env_stateless = function ()	return env_iter, nil, -1 end

mod.env = function ()
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
