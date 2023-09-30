local ffi = require("ffi")

ffi.cdef [[
	struct inotify_event {
		int wd;
		uint32_t mask;
		uint32_t cookie;
		uint32_t len;
		char name[];
	};
	int inotify_init(void);
	int inotify_init1(int flags);
	int inotify_add_watch(int fd, const char *pathname, uint32_t mask);
	int inotify_rm_watch(int fd, int wd);
]]

local mod = {}

--[[@class inotify_wd_c]]

--[[@class inotify_event_c]]
--[[@field wd inotify_wd_c]]
--[[@field mask inotify_event_mask]]
--[[@field cookie integer]]
--[[@field len integer]]
--[[@field name string_c]]

--[[@class inotify_ffi]]
--[[@field inotify_init fun(): fd_c]]
--[[@field inotify_init1 fun(flags: inotify_flag): fd_c]]
--[[@field inotify_add_watch fun(fd: fd_c, pathname: string, mask: inotify_event_mask): inotify_wd_c]]
--[[@field inotify_rm_watch fun(fd: fd_c, wd: inotify_wd_c): inotify_wd_c]]

--[[@enum inotify_flag]]
mod.flag = {
	IN_CLOEXEC = 0x00080000,
	IN_NONBLOCK = 0x00000800,
}

--[[@enum inotify_event_mask]]
mod.event_mask = {
	IN_ACCESS = 0x00000001, --[[File was accessed.]]
	IN_MODIFY = 0x00000002, --[[File was modified.]]
	IN_ATTRIB = 0x00000004, --[[Metadata changed.]]
	IN_CLOSE_WRITE = 0x00000008, --[[Writable file was closed.]]
	IN_CLOSE_NOWRITE = 0x00000010, --[[Unwritable file closed.]]
	IN_OPEN = 0x00000020, --[[File was opened.]]
	IN_MOVED_FROM = 0x00000040, --[[File was moved from X.]]
	IN_MOVED_TO = 0x00000080, --[[File was moved to Y.]]
	IN_CREATE = 0x00000100, --[[Subfile was created.]]
	IN_DELETE = 0x00000200, --[[Subfile was deleted.]]
	IN_DELETE_SELF = 0x00000400, --[[Self was deleted.]]
	IN_MOVE_SELF = 0x00000800, --[[Self was moved.]]
	IN_UNMOUNT = 0x00002000, --[[Backing fs was unmounted.]]
	IN_Q_OVERFLOW = 0x00004000, --[[Event queued overflowed.]]
	IN_IGNORED = 0x00008000, --[[File was ignored.]]
	IN_ONLYDIR = 0x01000000, --[[Only watch the path if it is a directory.]]
	IN_DONT_FOLLOW = 0x02000000, --[[Do not follow a sym link.]]
	IN_EXCL_UNLINK = 0x04000000, --[[Exclude events on unlinked objects.]]
	IN_MASK_CREATE = 0x10000000, --[[Only create watches.]]
	IN_MASK_ADD = 0x20000000, --[[Add to the mask of an already existing watch.]]
	IN_ISDIR = 0x40000000, --[[Event occurred against dir.]]
	IN_ONESHOT = 0x80000000, --[[Only send event once.]]
}
mod.event_mask.IN_CLOSE = bit.bor(mod.event_mask.IN_CLOSE_WRITE, mod.event_mask.IN_CLOSE_NOWRITE) --[[Close.]]
mod.event_mask.IN_MOVE = bit.bor(mod.event_mask.IN_MOVED_FROM, mod.event_mask.IN_MOVED_TO) --[[Move.]]
--[[All events which a program can wait on.]]
mod.event_mask.IN_ALL_EVENTS = bit.bor(
	mod.event_mask.IN_ACCESS, mod.event_mask.IN_MODIFY, mod.event_mask.IN_ATTRIB, mod.event_mask.IN_CLOSE_WRITE,
	mod.event_mask.IN_CLOSE_NOWRITE, mod.event_mask.IN_OPEN, mod.event_mask.IN_MOVED_FROM, mod.event_mask.IN_MOVED_TO,
	mod.event_mask.IN_CREATE, mod.event_mask.IN_DELETE, mod.event_mask.IN_DELETE_SELF, mod.event_mask.IN_MOVE_SELF
)
--[[@type table<inotify_event_mask, string>]]
mod.event_mask_name = {}
for k, v in pairs(mod.event_mask) do mod.event_mask_name[v] = k end

--[[@type inotify_ffi]]
local inotify_ffi = ffi.C

--[[@class inotify]]
local inotify = {
}
inotify.__index = inotify

--[[@param epoll epoll]] --[[@param flags? inotify_flag]]
inotify.new = function (self, epoll, flags)
	local fd
	if flags then fd = inotify_ffi.inotify_init1(flags)
	else fd = inotify_ffi.inotify_init() end
	local instance = { --[[@class inotify]]
		fd = fd,
		callbacks = {}, --[[@type table<inotify_wd_c, fun(event: inotify_event_c)>]]
	}
	local buf = ffi.new("char[65536]")
	epoll:add(fd, function ()
		local len = ffi.C.read(fd, buf, 65536)
		local offset = 0
		while offset < len do
			local event = ffi.cast("struct inotify_event *", buf + offset) --[[@type inotify_event_c]]
			local cb = instance.callbacks[event.wd]
			if cb then cb(event) end
			offset = offset + 16 + event.len
		end
	end)
	--[[FIXME: destructor]]
	return setmetatable(instance, self)
end
--[[@param epoll epoll]] --[[@param flags? inotify_flag]]
mod.new = function (epoll, flags) return inotify:new(epoll, flags) end

--[[@return fun() remove]] --[[@param pathname string]] --[[@param mask inotify_event_mask]] --[[@param cb fun(event: inotify_event_c)]]
inotify.add = function (self, pathname, mask, cb)
	local wd = inotify_ffi.inotify_add_watch(self.fd, pathname, mask)
	assert(wd >= 0, "inotify: inotify_add_watch failed")
	self.callbacks[wd] = cb
	return function ()
		inotify_ffi.inotify_rm_watch(self.fd, wd)
	end
end

mod.inotify = inotify

return mod
