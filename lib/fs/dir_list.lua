local ffi = require("ffi")
local path = require("lib.path")
local mod = {}

--[[@class file_info]]
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
			struct stat {
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
			};
			
			DIR *opendir(const char *name);
			struct dirent *readdir(DIR *dirp);
			int closedir(DIR *dirp);
			int stat(const char *restrict pathname, struct stat *restrict statbuf);
		]]

		--[[@class dir_c]]

		--[[@class dirent_c]]
		--[[@field d_ino integer]]
		--[[@field d_off integer]]
		--[[@field d_reclen integer]]
		--[[@field d_type integer]]
		--[[@field d_name string]]

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

		--[[@class dir_list_linux_ffi]]
		--[[@field opendir fun(name: string): dir_c]]
		--[[@field readdir fun(dirp: dir_c): dirent_c]]
		--[[@field closedir fun(dirp: dir_c)]]
		--[[@field stat fun(pathname: string, statbuf: { [0]: stat_c }): error_c]]

		local dir_list_ffi = ffi.C --[[@type dir_list_linux_ffi]]

		local stat = ffi.new("struct stat[1]") --[[@type { [0]: stat_c }]]

		--[[@return file_info? entry, string? error]] --[[@param self { dir: dir_c, path: string }]]
		local dir_list_iter = function (self)
			local entry = dir_list_ffi.readdir(self.dir)
			if entry == nil then
				local err = dir_list_ffi.closedir(self.dir)
				if err ~= 0 then return nil, "could not close directory" end
				return
			end
			local file_name = ffi.string(entry.d_name)
			local file_path = path.resolve(self.path, file_name)
			local err = dir_list_ffi.stat(file_path, stat)
			-- https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/stat.h#L23
			local is_dir = bit.band(stat[0].st_mode, 0xf000) == 0x4000
			local size = nil
			local created = tonumber(stat[0].st_ctime)
			local modified = tonumber(stat[0].st_mtime)
			if err == 0 then
				size = tonumber(stat[0].st_size)
			end
			return { name = file_name, is_dir = is_dir, size = size, created = created, modified = modified }
		end

		--[[@return (fun(self: { dir: dir_c, path: string }): file_info)? iterator, dir_c|string state_or_error]]
		--[[@param path_ string]]
		mod.dir_list = function (path_)
			if type(path_) ~= "string" then return nil, "dir_list: path must be a string" end
			local dir = dir_list_ffi.opendir(path_)
			if dir == nil then return nil, "dir_list: could not open directory" end
			dir_list_ffi.readdir(dir)
			dir_list_ffi.readdir(dir) -- assume first two entries are . and ..
			return dir_list_iter, { dir = dir, path = path_ }
		end
	end
end

--[[@return file_info[]? entries, string? error]] --[[@param path_ string]]
mod.dir_list = mod.dir_list or function (path_) return nil, "list_dir: os/processor not supported" end

return mod
