local ffi = require("ffi")
local fuse = require("lib.fuse")
local time = require("lib.time")

--[[TODO: go/rust compiler without extra fs artifacts]]
--[[TODO: npm script runner wrapper without physical node_modules]]
ffi.cdef [[
	void *memcpy(void *dest, const void *src, size_t n);
]]

--[[@type fun(obj: any): integer]]
local sizeof = ffi.sizeof
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local mk_buf = ffi.typeof("char [?]") --[[@type fun(size: integer): string_c]]

local mod = {}

--[[@class fuse_memory_entry]]
--[[@field data string_c?]]
--[[@field created number unix epoch]]
--[[@field modified number unix epoch]]
--[[@field children table<string,fuse_memory_entry>?]]

--[[@param root? fuse_memory_entry]]
mod.memory_fs = function (root)
	if not root then
		local now = time.time()
		root = { created = now, modified = now, children = {} }
	end
	--[[@return fuse_memory_entry? child, fuse_memory_entry parent, string name]]
	local find = function (path_c) --[[@param path_c string_c]]
		local path = ffi.string(path_c)
		local parent = nil
		local child = root
		local name --[[@type string]]
		local iter = path:gmatch("[^/]+")
		--[[@diagnostic disable-next-line: missing-return-value]]
		if iter() ~= "" then return end
		for segment in iter do
			--[[@diagnostic disable-next-line: missing-return-value]]
			if not parent then return end
			name = segment
			parent = child
			child = child.children[segment]
		end
		return child, parent, name
	end
	--[[@type fuse_operations_c]]
	return {
		--[[FIXME: use info]]
		read = function (path_c, buf, size, offset, info)
			local child = find(path_c)
			if not child then return fuse.error.no_entry end
			local actual_size = math.min(size, sizeof(child) - offset)
			ffi.C.memcpy(buf, child + offset, actual_size)
			return actual_size - offset
		end,
		--[[FIXME: use info]]
		write = function (path_c, buf, size, offset, info)
			local child, parent, name = find(path_c)
			if not parent then return fuse.error.no_entry end
			local actual_size = size + offset
			if not child then
				local now = time.time()
				child = { created = now, modified = now, data = mk_buf(actual_size) }
				parent[name] = child
			elseif sizeof(child.data) < actual_size then
				local data = mk_buf(actual_size)
				if offset > 0 then ffi.C.memcpy(data, child, math.min(sizeof(child.data), offset)) end
				if offset + size < sizeof(child.data) then
					ffi.C.memcpy(data, child, offset + size, sizeof(child.data) - offset - size)
				end
				child.data = data
				parent[name] = child
			end
			ffi.C.memcpy(child.data + offset, buf, actual_size)
			return size
		end,
		unlink = function (path_c)
			local child, parent, name = find(path_c)
			if not child then return fuse.error.no_entry end
			parent[name] = nil
			return fuse.error.success
		end,
	}
end

return mod
