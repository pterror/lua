#!/usr/bin/env luajit
if jit.os == "OSX" then
	--[[TODO:]]
else
	--[[assume posix]]
	os.execute("deps/lovr world_vr.lua")
end
