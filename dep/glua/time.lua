local ffi = require("ffi")

ffi.cdef [[
	struct timeval {
		long tv_sec;
		long tv_usec;
	};
	void gettimeofday(struct timeval *tv, void *p);
]]

local time = {}
local time_mt = {}
local timeval_mt = {}
setmetatable(time, time_mt)

time_mt.__call = function (_, ...)
	local now = time.new(...)
	ffi.C.gettimeofday(now, nil)
	return now
end

timeval_mt.__index = function (self, i)
	if i == "since" then
		local now = time()
		return tonumber(now.tv_sec) - tonumber(self.tv_sec) + tonumber(now.tv_usec - self.tv_usec) / 1000000.0
	end
	return nil
end

time.new = ffi.metatype("struct timeval", timeval_mt)

return time