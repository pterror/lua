local mod = {}

local list_routes
--[[@param routes_parts string[] ]] --[[@param routes http_table_handler]] --[[@param prefix? string]]
list_routes = function (routes_parts, routes, prefix)
	local keys = {} --[[@type string[] ]]
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	for k in pairs(routes) do keys[#keys+1] = k end
	table.sort(keys)
	for _, k in ipairs(keys) do
		local path = prefix and (prefix .. "/" .. k) or k
		local v = routes[k]
		--[[does not detect tables with a `__call` metamethod]]
		if k == "" or type(v) ~= "table" then
			if type(v) == "function" then routes_parts[#routes_parts+1] = path end
		else
			list_routes(routes_parts, v, path)
		end
	end
end

--[[@param routes http_table_handler]] --[[@param prefix? string]]
mod.list_routes_handler = function (routes, prefix)
	local html do
		local routes_parts = {} --[[@type string[] ]]
		list_routes(routes_parts, routes, prefix)
		for i, path in ipairs(routes_parts) do
			routes_parts[i] = [[<a href="]] .. (path ~= "" and path or ".") .. [[">]] .. (path ~= "" and path or "&nbsp;") .. [[</a><br/>]]
		end
		html = (
			[[<!doctype html>]] .. "\n" ..
			[[<style>@media (prefers-color-scheme: dark) { body { background: #222; color: white; } a { color: lightblue; } }</style>]] .. "\n" ..
			[[<link rel="stylesheet" href="/style.css">]] .. "\n" ..
			table.concat(routes_parts, "\n")
		)
	end
	--[[@param res http_response]]
	return function (_, res)
		res.headers["Content-Type"] = "text/html"
		res.body = html
	end
end

return mod
