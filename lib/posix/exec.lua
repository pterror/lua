local ffi = require("ffi")

--[[TODO: handle windows]]
ffi.cdef [[
	int execl(const char *path, const char *arg0, ... /*, (char *)0 */);
	int execv(const char *path, char *const argv[]);
	int execle(const char *path, const char *arg0, ... /*, (char *)0, char *const envp[]*/);
	int execve(const char *path, char *const argv[], char *const envp[]);
	int execlp(const char *file, const char *arg0, ... /*, (char *)0 */);
	int execvp(const char *file, char *const argv[]);
]]

--[[@class exec_posix_ffi]]
--[[@field execl fun(path: string, arg0: string, ...: string):integer]]
--[[@field execv fun(path: string, argv: string[]):integer]]
--[[@field execle fun(path: string, arg0: string, ...: string, envp: string[]):integer]]
--[[@field execve fun(path: string, argv: string[], envp: string[]):integer]]
--[[@field execlp fun(file: string, arg0: string, ...: string):integer]]
--[[@field execvp fun(file: string, argv: string[]):integer]]

--[[@type exec_posix_ffi]]
local exec_ffi = ffi.C

return exec_ffi
