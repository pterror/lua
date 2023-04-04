local ffi = require("ffi")

local mod = {}

if ffi.os == "Windows" then
	-- https://docs.microsoft.com/en-us/windows/win32/api/threadpoollegacyapiset/
	ffi.cdef [[
		HANDLE CreateTimerQueue();
		BOOL CreateTimerQueueTimer(
			PHANDLE phNewTimer,
			HANDLE TimerQueue,
			WAITORTIMERCALLBACK Callback,
			PVOID Parameter,
			DWORD DueTime,
			DWORD Period,
			ULONG Flags,
		);
		BOOL DeleteTimerQueueEx(
			HANDLE TimerQueue,
			HANDLE CompletionEvent,
		);
	]]
	-- FIXME
else
	-- https://github.com/torvalds/linux/blob/c766d1472c70d25ad475cf56042af1652e792b23/include/uapi/linux/time.h
	ffi.cdef [[
		struct timespec {
			long long tv_sec;
			long tv_nsec;
		};

		struct itimerspec {
			struct timespec it_interval;
			struct timespec it_value;
		};

		int close(int fd);
		ssize_t read(int fd, void *buf, size_t count);

		int timerfd_create(int clockid, int flags);
		int timerfd_settime(int fd, int flags, const struct itimerspec *new_value, struct itimerspec *old_value);
		int timerfd_gettime(int fd, struct itimerspec *curr_value);
	]]
	--- @class timespec
	--- @field tv_sec integer
	--- @field tv_nsec integer
	--- @class itimerspec
	--- @field it_interval timespec
	--- @field it_value timespec
	--- @class timerfd_c
	--- @field close fun(fd: integer): integer
	--- @field read fun(fd: integer, buf: ffi.cdata*, count: integer): integer
	--- @field timerfd_create fun(clockid: integer, flags: integer): integer
	--- @field timerfd_settime fun(fd: integer, flags: integer, new_value: itimerspec, old_value: { [0]: itimerspec }?): integer
	--- @field timerfd_gettime fun(fd: integer, curr_value: { [0]: itimerspec }): integer
	--- @type timerfd_c
	local timerfd_c = ffi.C

	--- @type fun(s: integer, ns: integer): timespec
	--- @diagnostic disable-next-line: assign-type-mismatch
	local timespec = ffi.typeof("struct timespec")
	--- @type fun(interval: timespec, value: timespec): itimerspec
	--- @diagnostic disable-next-line: assign-type-mismatch
	local itimerspec = ffi.typeof("struct itimerspec")
	local rdbuf = ffi.new("char[8]")

	local timespec0 = timespec(0, 0)

	--- @return fun() clear_timeout
	--- @param self epoll
	--- @param ms integer
	--- @param cb fun()
	mod.set_timeout = function (self, ms, cb)
		local value = timespec(math.floor(ms / 1000), (ms % 1000) * 1000000)
		local fd = timerfd_c.timerfd_create(--[[CLOCK_MONOTONIC]] 1, 0)
		assert(fd >= 0, "timerfd_create failed")
		assert(timerfd_c.timerfd_settime(fd, 0, itimerspec(timespec0, value), nil) == 0, "timerfd_settime failed")
		local _, remove
		_, remove = self:add(fd, function ()
			cb() -- needs wrapping to make sure arg count is 0
			timerfd_c.read(fd, rdbuf, 8)
			timerfd_c.close(fd)
			remove()
		end)
		assert(remove, "epoll:add failed")
		return function ()
			timerfd_c.close(fd)
			remove()
		end
	end

	--- @return fun() clear_interval
	--- @param self epoll
	--- @param ms integer
	--- @param cb fun()
	mod.set_interval = function (self, ms, cb)
		local value = timespec(math.floor(ms / 1000), (ms % 1000) * 1000000)
		local fd = timerfd_c.timerfd_create(--[[CLOCK_MONOTONIC]] 1, 0)
		assert(fd >= 0, "timerfd_create failed")
		assert(timerfd_c.timerfd_settime(fd, 0, itimerspec(value, value), nil) == 0, "timerfd_settime failed")
		local _, remove
		_, remove = self:add(fd, function ()
			cb() -- needs wrapping to make sure arg count is 0
			timerfd_c.read(fd, rdbuf, 8)
		end)
		assert(remove, "epoll:add failed")
		return function ()
			timerfd_c.close(fd)
			remove()
		end
	end
end
-- should handle other OSes too

return mod
