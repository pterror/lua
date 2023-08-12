#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ffi = require("ffi")

--[[https://elixir.bootlin.com/linux/latest/source/include/uapi/asm-generic/signal.h]]
local signals = {
  sighup = 1, sigint = 2, sigquit = 3, sigill = 4, sigtrap = 5, sigabrt = 6, sigiot = 6, sigbus = 7,
  sigfpe = 8, sigkill = 9, sigusr1 = 10, sigsegv = 11, sigusr2 = 12, sigpipe = 13, sigalrm = 14,
  sigterm = 15, sigstkflt = 16, sigchld = 17, sigcont = 18, sigstop = 19, sigtstp = 20, sigttin = 21,
  sigttou = 22, sigurg = 23, sigxcpu = 24, sigxfsz = 25, sigvtalrm = 26, sigprof = 27, sigwinch = 28,
  sigio = 29, sigpoll = 29, sigpwr = 30, sigsys = 31, sigunused = 31,
}

ffi.cdef [[ int raise(int sig); ]]

local id = arg[1] and string.lower(arg[1])
ffi.C.raise(tonumber(id) or signals[id] or signals["sig" .. id])
