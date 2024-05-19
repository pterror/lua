local mod = {}

--[[@param routes http_table_handler]]
mod.router = function (routes)
	--[[@type http_callback]]
	return function (req, res, sock)
		local route = routes
		if type(route) == "function" then
			local success = route(req, res, sock)
			return success == nil or success
		end
		local start
		local end_ = 0
		local part
		repeat
			--[[@diagnostic disable-next-line: cast-local-type]]
			start, end_, part = req.path:find("/([^/]*)", end_ + 1)
			local new_route = route[part]
			if not new_route then
				new_route = route[1]
				local globs = req.globs or {}
				globs[#globs+1] = part
				req.globs = globs
			end
			route = new_route
			if type(route) == "function" then
				if end_ < #req.path then req.globs.rest = req.path:sub(end_ + 1) end
				local success = route(req, res, sock)
				return success == nil or success
			elseif route == nil then return end
		until end_ == #req.path
		route = route[""]
		if type(route) == "function" then
			if end_ < #req.path then req.globs.rest = req.path:sub(end_ + 1) end
			local success = route(req, res, sock)
			return success == nil or success
		end
	end
end

return mod
