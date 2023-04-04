local mod = {}

--[[@param routes http_table_handler]]
mod.table_router = function (routes)
	--[[@return boolean?]] --[[@param req http_request]] --[[@param res http_response]]
	return function (req, res)
		local route = routes
		if type(route) == "function" then
			return route(req, res)
		end
		for part in req.path:gmatch("/([^/]*)") do
			local new_route = route[part]
			if not new_route then
				new_route = route[1]
				local globs = req.globs or {}
				globs[#globs+1] = part
				req.globs = globs
			end
			route = new_route
			if type(route) == "function" then return route(req, res)
			elseif route == nil then return end
		end
		route = route[""]
		if type(route) == "function" then return route(req, res) end
	end
end

return mod
