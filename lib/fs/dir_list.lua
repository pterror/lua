local ffi = require("ffi")

--[[@diagnostic disable-next-line: undefined-global]]
if register_ffi_module then register_ffi_module("lib.fs.dir_list") end

local mod = {}

--[[@class file_info]]
--[[@field path string]]
--[[@field name string]]
--[[@field is_dir boolean]]
--[[@field size? integer]]
--[[@field created? integer]]
--[[@field modified? integer]]

-- FIXME: refactor directory listing out?
-- it'd result in duplication of work tho
-- (you can't check whether a file is a directory...)
if ffi.os == "Linux" then
	if ffi.arch == "x64" then
		ffi.cdef [[
			typedef unsigned int ino_t;
			typedef int off_t;
			// https://elixir.bootlin.com/linux/latest/source/tools/include/nolibc/std.h
			typedef unsigned /* int */ long dev_t;
			typedef unsigned long ino_t;
			typedef unsigned /* int */ long mode_t;
			typedef signed int pid_t;
			typedef unsigned int uid_t;
			typedef unsigned int gid_t;
			typedef unsigned long nlink_t;
			typedef signed long off_t;
			typedef signed long blksize_t;
			typedef signed long blkcnt_t;
			typedef signed long time_t;
			typedef void DIR;
			// https://codebrowser.dev/glibc/glibc/sysdeps/unix/sysv/linux/bits/dirent.h.html#dirent
			struct dirent {
				ino_t d_ino;
				off_t d_off;
				unsigned short d_reclen;
				unsigned char d_type;
				char _padding[8]; // TODO: why? probably reclen and type need more padding
				char d_name[256];
			};
			// https://codebrowser.dev/glibc/glibc/sysdeps/unix/sysv/linux/x86/bits/struct_stat.h.html#stat
			/* struct stat {
				dev_t st_dev;
				ino_t st_ino;
				nlink_t st_nlink; // nlink and mode are reversed on 64-bit
				mode_t st_mode;
				uid_t st_uid;
				gid_t st_gid;
				dev_t st_rdev;
				off_t st_size;
				blksize_t st_blksize;
				blkcnt_t st_blocks;
				// https://man7.org/linux/man-pages/man3/clock_gettime.3.html
				// inlined:
				// struct timespec { time_t tv_sec; long tv_nsec; };
				// struct timespec st_atim;
				// struct timespec st_mtim;
				// struct timespec st_ctim;
				time_t st_atime;
				long st_atime_ns;
				time_t st_mtime;
				long st_mtime_ns;
				time_t st_ctime;
				long st_ctime_ns;
				long __glibc_reserved[3];
			}; */

			// https://codebrowser.dev/glibc/glibc/io/bits/types/struct_statx.h.html
			struct statx {
				uint32_t stx_mask;
				uint32_t stx_blksize;
				uint64_t stx_attributes;
				uint32_t stx_nlink;
				uint32_t stx_uid;
				uint32_t stx_gid;
				uint16_t stx_mode;
				uint16_t __statx_pad1[1];
				uint64_t stx_ino;
				uint64_t stx_size;
				uint64_t stx_blocks;
				uint64_t stx_attributes_mask;
				// `struct statx_timestamp` inlined:
				// https://codebrowser.dev/glibc/glibc/io/bits/types/struct_statx_timestamp.h.html
				int64_t stx_atime_sec;
				uint32_t stx_atime_nsec;
				int32_t __stx_atime_pad1[1];
				int64_t stx_btime_sec;
				uint32_t stx_btime_nsec;
				int32_t __stx_btime_pad1[1];
				int64_t stx_ctime_sec;
				uint32_t stx_ctime_nsec;
				int32_t __stx_ctime_pad1[1];
				int64_t stx_mtime_sec;
				uint32_t stx_mtime_nsec;
				int32_t __stx_mtime_pad1[1];
				uint32_t stx_rdev_major;
				uint32_t stx_rdev_minor;
				uint32_t stx_dev_major;
				uint32_t stx_dev_minor;
				uint64_t __statx_pad2[14];
			};
			
			DIR *opendir(const char *name);
			struct dirent *readdir(DIR *dirp);
			int closedir(DIR *dirp);
			// int stat(const char *restrict pathname, struct stat *restrict statbuf);
			int statx(int dirfd, const char *restrict pathname, int flags, unsigned int mask, struct statx *restrict statxbuf);
		]]

		--[[@class dir_c]]

		--[[@class dirent_c]]
		--[[@field d_ino integer]]
		--[[@field d_off integer]]
		--[[@field d_reclen integer]]
		--[[@field d_type integer]]
		--[[@field d_name string_c]]

		--[[@class stat_c]]
		--[[@field st_dev integer]]
		--[[@field st_ino integer]]
		--[[@field st_mode integer]]
		--[[@field st_nlink integer]]
		--[[@field st_uid integer]]
		--[[@field st_gid integer]]
		--[[@field st_rdev integer]]
		--[[@field st_size integer]]
		--[[@field st_blksiz integer]]
		--[[@field st_blocks integer]]
		--[[@field st_atime integer]]
		--[[@field st_atime_ns integer]]
		--[[@field st_mtime integer]]
		--[[@field st_mtime_ns integer]]
		--[[@field st_ctime integer]]
		--[[@field st_ctime_ns integer]]

		--[[@class statx_c]]
		--[[@field stx_mask integer]]
		--[[@field stx_blksize integer]]
		--[[@field stx_attributes integer]]
		--[[@field stx_nlink integer]]
		--[[@field stx_uid integer]]
		--[[@field stx_gid integer]]
		--[[@field stx_mode integer]]
		--[[@field stx_ino integer]]
		--[[@field stx_size integer]]
		--[[@field stx_blocks integer]]
		--[[@field stx_attributes_mask integer]]
		--[[@field stx_atime_sec integer]]
		--[[@field stx_atime_nsec integer]]
		--[[@field stx_btime_sec integer]]
		--[[@field stx_btime_nsec integer]]
		--[[@field stx_ctime_sec integer]]
		--[[@field stx_ctime_nsec integer]]
		--[[@field stx_mtime_sec integer]]
		--[[@field stx_mtime_nsec integer]]
		--[[@field stx_rdev_major integer]]
		--[[@field stx_rdev_minor integer]]
		--[[@field stx_dev_major integer]]
		--[[@field stx_dev_minor integer]]

		--[[@class dir_list_linux_ffi]]
		--[[@field opendir fun(name: string): dir_c]]
		--[[@field readdir fun(dirp: dir_c): dirent_c]]
		--[[@field closedir fun(dirp: dir_c)]]
		--[[@field statx fun(dirfd: integer, pathname: string, flags: integer, mask: integer, statbuf: ptr_c<statx_c>): error_c]]
		--[[@f ield stat fun(pathname: string, statbuf: ptr_c<stat_c>): error_c]]

		local dir_list_ffi = ffi.C --[[@type dir_list_linux_ffi]]

		local stat = ffi.new("struct statx[1]") --[[@type { [0]: statx_c }]]

		--[[@return file_info? entry, string? error]] --[[@param self { dir: dir_c, path: string }]]
		local dir_list_iter = function (self)
			local entry = dir_list_ffi.readdir(self.dir)
			if entry == nil then
				local err = dir_list_ffi.closedir(self.dir)
				if err ~= 0 then return nil, "dir_list: could not close directory" end
				return
			end
			local file_name = ffi.string(entry.d_name)
			local file_path = self.path .. "/" .. file_name
			--[[https://codebrowser.dev/glibc/glibc/io/fcntl.h.html#_M/AT_FDCWD]]
			--[[https://codebrowser.dev/glibc/glibc/io/bits/statx-generic.h.html#_M/STATX_ALL]]
			local err = dir_list_ffi.statx(-100 --[[AT_FDCWD]], file_path, 0, 0xfff --[[STATX_ALL]], stat)
			return {
				name = file_name, path = file_path,
				--[[https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/stat.h#L23]]
				is_dir = bit.band(stat[0].stx_mode, 0xf000) == 0x4000,
				size = err == 0 and tonumber(stat[0].stx_size) or 0,
				created = tonumber(stat[0].stx_btime_sec) + tonumber(stat[0].stx_btime_nsec) / 1000000000,
				modified = tonumber(stat[0].stx_mtime_sec) + tonumber(stat[0].stx_mtime_nsec) / 1000000000,
			}
		end

		--[[@return (fun(self: { dir: dir_c, path: string }): file_info)? iterator, dir_c|string state_or_error]]
		--[[@param path string]]
		mod.dir_list = function (path)
			path = path or "."
			if type(path) ~= "string" then return nil, "dir_list: path must be a string" end
			local dir = dir_list_ffi.opendir(path)
			if dir == nil then return nil, "dir_list: could not open directory" end
			--[[assume first two entries are . and ..]]
			dir_list_ffi.readdir(dir)
			dir_list_ffi.readdir(dir)
			return dir_list_iter, { dir = dir, path = path }
		end

		--[[@return file_info? info, string? error]] --[[@param path string]]
		mod.dir_info = function (path)
			path = path or "."
			if type(path) ~= "string" then return nil, "dir_info: path must be a string" end
			local dir = dir_list_ffi.opendir(path)
			if dir == nil then return nil, "dir_info: could not open directory" end
			local result = dir_list_iter({ dir = dir, path = path })
			dir_list_ffi.closedir(dir)
			result.path = path
			return result
		end
	end
elseif ffi.os == "Windows" then
	ffi.cdef [[
		typedef unsigned short WORD;
		typedef unsigned long DWORD;
		typedef void *HANDLE;
		typedef const void *LPCVOID;
		typedef char CHAR;
		typedef const char *LPCSTR;

		typedef struct _FILETIME {
			DWORD dwLowDateTime;
			DWORD dwHighDateTime;
		} FILETIME, *PFILETIME, *LPFILETIME;

		typedef struct _WIN32_FIND_DATA {
			DWORD dwFileAttributes;
			FILETIME ftCreationTime;
			FILETIME ftLastAccessTime;
			FILETIME ftLastWriteTime;
			DWORD nFileSizeHigh;
			DWORD nFileSizeLow;
			DWORD dwReserved0;
			DWORD dwReserved1;
			CHAR cFileName[260 /*MAX_PATH*/];
			CHAR cAlternateFileName[14];
			DWORD dwFileType; // obsolete
			DWORD dwCreatorType; // obsolete
			WORD wFinderFlags; // obsolete
		} WIN32_FIND_DATA, *PWIN32_FIND_DATA, *LPWIN32_FIND_DATA;

		HANDLE FindFirstFileA(LPCSTR lpFileName, LPWIN32_FIND_DATA lpFindFileData);
		bool FindNextFileA(HANDLE hFindFile, LPWIN32_FIND_DATA lpFindFileData);
		bool FindClose(HANDLE hFindFile);
		DWORD GetLastError();
		DWORD FormatMessageA(DWORD dwFlags, LPCVOID lpSource, DWORD dwMessageId, DWORD dwLanguageId, LPCSTR lpBuffer, DWORD nSize, va_list *Arguments);
	]]

	--[[@class win32_find_file_handle_c]]

	--[[@class win32_filetime_c]]
	--[[@field dwLowDateTime integer]]
	--[[@field dwHighDateTime integer]]

	--[[@class win32_find_data_c]]
	--[[@field dwFileAttributes integer]]
	--[[@field ftCreationTime win32_filetime_c]]
	--[[@field ftLastAccessTime win32_filetime_c]]
	--[[@field ftLastWriteTime win32_filetime_c]]
	--[[@field nFileSizeHigh integer]]
	--[[@field nFileSizeLow integer]]
	--[[@field dwReserved0 integer]]
	--[[@field dwReserved1 integer]]
	--[[@field cFileName string_c]]
	--[[@field cAlternateFileName string_c]]
	--[[@field dwFileType integer obsolete]]
	--[[@field dwCreatorType integer obsolete]]
	--[[@field wFinderFlags integer obsolete]]

	--[[@class dir_list_windows_ffi]]
	--[[@field FindFirstFileA fun(lpFileName: string, lpFindFileData: ptr_c<win32_find_data_c>): win32_find_file_handle_c]]
	--[[@field FindNextFileA fun(hFindFile: win32_find_file_handle_c, lpFindFileData: ptr_c<win32_find_data_c>): boolean]]
	--[[@field FindClose fun(hFindFile: ptr_c<win32_find_file_handle_c>): boolean]]
	--[[@field GetLastError fun(): integer]]
	--[[@field FormatMessageA fun(dwFlags: integer, lpSource: ffi.cdata*?, dwMessageId: integer, dwLanguageId: integer, lpBuffer: string, nSize: integer, ...)]]

	local dir_list_ffi = ffi.C --[[@type dir_list_windows_ffi]]

	local err_buf = ffi.new("char[512]")
	local entry = ffi.new("WIN32_FIND_DATA[1]") --[[@type ptr_c<win32_find_data_c>]]

	--[[@return file_info? entry, string? error]] --[[@param self { dir: win32_find_file_handle_c, path: string }]]
	local dir_list_iter = function (self)
		local success = dir_list_ffi.FindNextFileA(self.dir, entry)
		if not success then
			local err = dir_list_ffi.GetLastError()
			if err ~= 18 --[[ERROR_NO_MORE_FILES]] then
				--[[FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000, FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200]]
				local len = dir_list_ffi.FormatMessageA(0x00001200, nil, dir_list_ffi.GetLastError(), 0, err_buf, 512, nil)
				return nil, "dir_list: " .. ffi.string(err_buf, len - 2)
			end
			success = dir_list_ffi.FindClose(self.dir)
			if not success then return nil, "dir_list: could not close directory" end
			return
		end
		local file_name = ffi.string(entry[0].cFileName)
		return {
			name = file_name,
			path = self.path .. "\\" .. file_name,
			is_dir = bit.band(entry[0].dwFileAttributes, 0x10 --[[FILE_ATTRIBUTE_DIRECTORY]]) ~= 0,
			size = tonumber(entry[0].nFileSizeHigh * 0x100000000 + entry[0].nFileSizeLow),
			created = tonumber((entry[0].ftCreationTime.dwHighDateTime * 0x100000000ULL + entry[0].ftCreationTime.dwLowDateTime) / 10000000ULL - 11644473600ULL),
			modified = tonumber((entry[0].ftLastAccessTime.dwHighDateTime * 0x100000000ULL + entry[0].ftLastAccessTime.dwLowDateTime) / 10000000ULL - 11644473600ULL),
		}
	end

	--[[@return (fun(self: { dir: dir_c, path: string }): file_info)? iterator, dir_c|string state_or_error]]
	--[[@param path string]]
	mod.dir_list = function (path)
		path = path or "."
		if type(path) ~= "string" then return nil, "dir_list: path must be a string" end
		local dir = dir_list_ffi.FindFirstFileA(path .. "\\*", entry)
		dir_list_ffi.FindNextFileA(dir, entry) --[[assume first two entries are . and ..]]
		if dir == nil then return nil, "dir_list: could not open directory" end
		return dir_list_iter, { dir = dir, path = path }
	end

	--[[@return file_info? info, string? error]] --[[@param path string]]
	mod.dir_info = function (path)
		path = path or "."
		if type(path) ~= "string" then return nil, "dir_list: path must be a string" end
		local dir = dir_list_ffi.FindFirstFileA(path .. "\\*", entry)
		if dir == nil then return nil, "dir_info: could not open directory" end
		local result = dir_list_iter({ dir = dir, path = path })
		local success = dir_list_ffi.FindClose(dir)
		if not success then return nil, "dir_info: could not close directory" end
		result.path = path
		return result
	end
end

--[[@return file_info[]? entries, string? error]] --[[@param path string]]
mod.dir_list = mod.dir_list or function (path) return nil, "dir_list: os/processor not supported" end
--[[@return file_info? info, string? error]] --[[@param path string]]
mod.dir_info = mod.dir_info or function (path) return nil, "dir_info: dir_info: os/processor not supported" end

return mod
