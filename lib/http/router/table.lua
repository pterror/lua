--[[@alias http_table_handler http_callback | table<string, http_callback|table<string, http_callback|table<string, http_callback|table<string, http_callback|http_table_handler>>>>]]

local mod = {}

--[[@param routes http_table_handler]]
mod.table_router = function (routes)
	--[[LINT: it'd be nice if @type lua_http_handler worked]]
	--[[@return nil]] --[[@param req http_request]] --[[@param res http_response]]
	return function (req, res)
		local route = routes
		if type(route) == "function" then return route(req, res) end
		for part in req.path:gmatch("/([^/]*)") do
			route = route[part]
			if type(route) == "function" then return route(req, res)
			elseif route == nil then return end
		end
	end
end

return mod
