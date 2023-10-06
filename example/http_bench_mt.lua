#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local ffi = require("ffi")
local epoll = require("dep.epoll").new()

ffi.cdef [[int /*pid_t*/ fork(void);]]

--[[currently broken]]

local i = 0
require("lib.http.server").server(function (_, res)
	i = i + 1
	if i % 1000 == 0 then print(i) end
	res.headers["Content-Type"] = "text/html"
	res.body = [[
<!doctype html>
<meta charset="utf-8">
<title>redbean</title>
<link rel="stylesheet" href="redbean.css">
<img src="/redbean.png" class="logo" width="84" height="84">

<h2>
	<big>page copied from redbean for benchmarking</big><br>
	<small>distributable static web server</small>
</h2>

<p>
	Here's what you need to know about redbean:

<ul>
<li>million qps on modern pc
<li>container is executable zip file
<li>userspace filesystem w/o syscall overhead
<li>kernelspace zero-copy gzip encoded responses
<li>executable runs on linux, bsd, mac, and windows
</ul>

<p>
	redbean is based on <a href="https://justine.storage.googleapis.com/ape.html">αcτµαlly pδrταblε εxεcµταblε</a>
	and <a href="https://github.com/jart/cosmopolitan">cosmopolitan</a>.
	<br>
	redbean is authored by Justine Tunney who's on
	<a href="https://github.com/jart">GitHub</a> and
	<a href="https://twitter.com/JustineTunney">Twitter</a>.]]
	--[[@diagnostic disable-next-line: param-type-mismatch]]
end, tonumber(arg[1] or os.getenv("PORT") or os.getenv("port")), epoll)

for _ = 1, 15 do if ffi.C.fork() ~= 0 then break end end
epoll:loop()
