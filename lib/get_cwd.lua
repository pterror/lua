local ffi = require("ffi")

local mod = {}

-- posix max size is 4096; windows max size is 256/260/32767
local MAX_PATH_LENGTH = 4096

ffi.cdef [[
	char *getcwd(char *buf, size_t size);
]]
-- TODO: consistent naming
--- @class getcwd_ns
--- @field getcwd fun(buf: ffi.cdata*, size: integer)
--- @type getcwd_ns
local getcwd_ns = ffi.C

local filename_buf = ffi.new("char[?]", MAX_PATH_LENGTH)

mod.get_cwd = function ()
	getcwd_ns.getcwd(filename_buf, MAX_PATH_LENGTH)
	-- TODO: handle errors
	return ffi.string(filename_buf)
end

return mod
