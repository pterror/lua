-- FIXME: finish
local ffi = require("ffi")

local mod = {}

if ffi.os == "Linux" then
	ffi.cdef [[
		int inotify_init(void);
		int inotify_init1(int flags);
		int inotify_add_watch(int fd, const char *pathname, uint32_t mask);
		int inotify_rm_watch(int fd, int wd);
	]]
elseif ffi.os == "Windows" then
	ffi.cdef [[
		HANDLE FindFirstChangeNotificationA(LPCSTR lpPathName, BOOL bWatchSubtree, DWORD  dwNotifyFilter);
		BOOL FindNextChangeNotification(HANDLE hChangeHandle);
		BOOL FindCloseChangeNotification(HANDLE hChangeHandle);
		BOOL ReadDirectoryChangesW(
			HANDLE hDirectory, /*out*/ LPVOID lpBuffer, DWORD nBufferLength, BOOL bWatchSubtree, DWORD dwNotifyFilter,
			/*out, optional*/ LPDWORD lpBytesReturned, /*in, out, optional*/ LPOVERLAPPED lpOverlapped,
			/*in, optional*/ LPOVERLAPPED_COMPLETION_ROUTINE lpCompletionRoutine
		);
	]]
end

return mod
