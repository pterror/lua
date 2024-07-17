#!/usr/bin/env luajit
local ver = "v0.17.1"
local name = "lovr"

local sh = function(cmd) --[[@param cmd string]]
	--[[@return string?]]
	local f = io.popen(cmd)
	local ret = f and f:read("*all"):gsub("\n$", "")
	if f then f:close() end
	return ret
end

if jit.os == "OSX" then
	--[[TODO:]]
else
	--[[assume posix]]
	local deps = sh([[realpath "]] .. arg[0] .. [["]]):gsub("/([^/]+)/([^/]+)$", "") .. "/deps/"
	os.execute("mkdir -p " .. deps)
	local bin = "lovr-" .. ver .. "-x86_64.AppImage"
	local file = io.open(deps .. bin)
	if file then
		file:close()
	else
		os.execute("curl -L https://github.com/bjornbytes/lovr/releases/download/" ..
			ver .. "/" .. bin .. " -o " .. deps .. bin)
		local uname = sh("uname -v") or ""
		if uname:find("NixOS") then
			local wrapper = assert(io.open(deps .. name, "w"))
			wrapper:write([[
#!/bin/sh
nix run nixpkgs#appimage-run ]] .. deps .. bin .. [[ $@]])
			os.execute("chmod +x deps/" .. name)
		else
			os.execute("chmod +x deps/" .. bin)
			os.execute("ln -s ./" .. bin .. " " .. deps .. name)
		end
	end
end
