local ffi = require("ffi")

local mod = {}

if jit.os == "Windows" then
	--[[FIXME: dir_list also defines filetime]]
	ffi.cdef [[
		typedef struct _FILETIME {
			DWORD dwLowDateTime;
			DWORD dwHighDateTime;
		} FILETIME, *PFILETIME, *LPFILETIME;
		void GetSystemTimeAsFileTime(LPFILETIME lpSystemTimeAsFileTime);
	]]

	--[[@class time_ffi_windows]]
	--[[@field GetSystemTimeAsFileTime fun(lpSystemTimeAsFileTime: win32_filetime_c)]]

	--[[@type time_ffi_windows]]
	local time_ffi = ffi.C

	local time = ffi.new("FILETIME[1]") --[[@type ptr_c<win32_filetime_c>}]]

	mod.time = function ()
		time_ffi.GetSystemTimeAsFileTime(time)
		return tonumber((time[0].dwHighDateTime * 0x100000000ULL + time[0].dwLowDateTime) / 10000000ULL - 11644473600ULL)
	end
else
	ffi.cdef [[
		struct timeval {
			long tv_sec;
			long tv_usec;
		};
		struct timezone {
			int tz_minuteswest;
			int tz_dsttime;
		};
		void gettimeofday(struct timeval *tv, struct timezone *tz);
	]]

	--[[@class timeval_c]]
	--[[@field tv_sec integer]]
	--[[@field tv_usec integer]]

	--[[@class timezone_c]]
	--[[@field tz_minuteswest integer]]
	--[[@field tz_dsttime integer]]

	--[[@class time_ffi_linux]]
	--[[@field gettimeofday fun(tv: ptr_c<timeval_c>, tz: ptr_c<timezone_c>?)]]

	--[[@type time_ffi_linux]]
	local time_ffi = ffi.C

	local time = ffi.new("struct timeval [1]") --[[@type ptr_c<timeval_c>]]

	mod.time = function ()
		time_ffi.gettimeofday(time, nil)
		return tonumber(time[0].tv_sec) + tonumber(time[0].tv_usec) / 1000000
	end
end

return mod
