local fuse = require("lib.fuse")

local mod = {}

local ro_cb = function () return fuse.error.read_only_file_system end

--[[@return fuse_operations_c]] --[[@param ops fuse_operations_c]]
mod.readonly = function (ops)
	--[[@type fuse_operations_c]]
	local ro_ops = {
		write = ro_cb, write_buf = ro_cb, symlink = ro_cb, link = ro_cb, rename = ro_cb, unlink = ro_cb,
		copy_file_range = ro_cb, chmod = ro_cb, chown = ro_cb, create = ro_cb, destroy = ro_cb, fallocate = ro_cb,
		flush = ro_cb, setxattr = ro_cb, flock = ro_cb, ioctl = ro_cb, rmdir = ro_cb, mkdir = ro_cb, mknod = ro_cb,
		access = function (path, flags) --[[FIXME: reject R_OK]]
			if bit.band(flags, 4 --[[R_OK]]) then return fuse.error.read_only_file_system
			elseif ops.access then return ops.access(path, flags)
			else return fuse.error.not_implemented end
		end,
	}
	return setmetatable(ro_ops, { __index = ops })
end

return mod
