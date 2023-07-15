#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local server = require("lib.http.server").server

local browser_precedence = { firefox = 1, safari = 1, chrome = 2, edg = 3, opr = 3 }
local is_client = { c = true, client = true, b = true, browser = true }

server(function (req, res, sock)
	local pathname = (req.path:match("^/(.-)[?#]") or {})[2] or req.path --[[@type string]]
	pathname = pathname:lower():gsub("[^a-z]+", "")
	if pathname == "ip" then
		res.body = sock:get_name()
	elseif pathname == "h" or pathname == "headers" then
		local parts = {}
		for k, v_ in pairs(req.headers) do
			for _, v in ipairs(v_) do parts[#parts+1] = k .. ": " .. v end
		end
		parts[#parts+1] = ""
		res.body = table.concat(parts, "\r\n")
	elseif pathname == "ua" or pathname == "useragent" then
		res.body = (req.headers["user-agent"] or {})[1] or ""
	elseif is_client[pathname] then
		local ua = (req.headers["user-agent"] or {})[1] or ""
		res.body = ua
		local prec = 0
		for browser, version in ua:gmatch("([%S]-)/([%d.]+)") do
			local new_prec = browser_precedence[browser:lower()] or 0
			if new_prec >= prec then prec = new_prec; res.body = browser .. "/" .. version end
		end
	end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
end, tonumber(arg[1] or os.getenv("port") or os.getenv("PORT")))
