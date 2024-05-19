--[[@alias api_callback fun(input: unknown): unknown]]
--[[@alias api_table_handler api_callback | table<string, api_callback|table<string, api_callback|table<string, api_callback|table<string, api_callback|api_table_handler>>>>]]
local mod = {}

local json_to_value = require("dep.lunajson").json_to_value
local value_to_json = require("dep.lunajson").value_to_json

--[[@param routes api_table_handler]]
mod.router = function (routes)
	--[[@type http_callback]]
	return function (req, res, sock)
		local route = routes
		if type(route) == "function" then
			local input = json_to_value(req.body)
			res.headers["Content-Type"] = "application/json"
			res.body = value_to_json(route(input))
			return true
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
				--[[FIXME: apis don't have access to req.globs]]
				if end_ < #req.path then req.globs.rest = req.path:sub(end_ + 1) end
				local input = json_to_value(req.body)
				res.headers["Content-Type"] = "application/json"
				res.body = value_to_json(route(input))
				return true
			elseif route == nil then return end
		until end_ == #req.path
		route = route[""]
		if type(route) == "function" then
			if end_ < #req.path then req.globs.rest = req.path:sub(end_ + 1) end
			local input = json_to_value(req.body)
			res.headers["Content-Type"] = "application/json"
			res.body = value_to_json(route(input))
			return true
		end
	end
end

return mod
