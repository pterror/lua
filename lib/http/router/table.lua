--[[@alias http_table_handler http_callback | table<string, http_callback|table<string, http_callback|table<string, http_callback|table<string, http_callback|http_table_handler>>>>]]

local mod = {}

--[[@param routes http_table_handler]]
mod.table_router = function (routes)
	--[[@type http_callback]]
	return function (req, res, sock)
		local route = routes
		if type(route) == "function" then return route(req, res, sock) end
		for part in req.path:gmatch("/([^/]*)") do
			route = route[part]
			if type(route) == "function" then return route(req, res, sock)
			elseif route == nil then return end
		end
	end
end

return mod
