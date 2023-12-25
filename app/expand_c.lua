#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local parts = {} --[[@type string[] ]]

for _, val in ipairs(arg) do
	parts[#parts+1] = "RESULT_" .. val .. "=__STR__(" .. val .. ")\n"
end

--[[FIXME: make this work on windows, which probably doesn't use cc]]
local f = assert(io.popen([[
cat <<'END' | cc -E -
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <float.h>
#include <limits.h>
#include <stdint.h>
#include <wctype.h>
#include <errno.h>
#if defined(WIN32) || defined(WIN16)
#include <conio.h>
#else
#include <unistd.h>

#include <fcntl.h>
#include <sys/syscall.h>
#include <sys/epoll.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#endif
#define __STR___(a) #a
#define __STR__(a) __STR___(a)
]] .. table.concat(parts) .. [[

END
]], "r"))

while true do
	local line = f:read("*line") --[[@type string]]
	if not line then break end
	local name, value = line:match("RESULT_(.-=)\"(.+)\"")
	if name then print(name .. value) end
end
