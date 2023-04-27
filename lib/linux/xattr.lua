local ffi = require("ffi")

local mod = {}

ffi.cdef [[
	ssize_t getxattr(const char *path, const char *name, void *value, size_t size);
	ssize_t lgetxattr(const char *path, const char *name, void *value, size_t size);
	ssize_t fgetxattr(int fd, const char *name, void *value, size_t size);
]]

--[[@class xattr_ffi]]
--[[@field getxattr fun(path: string, name: string, value: ffi.cdata*, size: integer): integer]]
--[[@field lgetxattr fun(path: string, name: string, value: ffi.cdata*, size: integer): integer]]
--[[@field fgetxattr fun(fd: fd_c, name: string, value: ffi.cdata*, size: integer): integer]]

--[[@type xattr_ffi]]
local xattr_ffi = ffi.C

mod.getxattr = xattr_ffi.getxattr
mod.lgetxattr = xattr_ffi.lgetxattr
mod.fgetxattr = xattr_ffi.fgetxattr

return mod
