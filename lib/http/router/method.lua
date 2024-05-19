--[[@alias http_method_handler table<http_method, http_callback>]]

local mod = {}

--[[@param cbs http_method_handler]]
mod.router = function (cbs)
	--[[@type http_callback]]
	return function (req, res, sock)
		local cb = cbs[req.method]
		if cb then return cb(req, res, sock) end
	end
end

return mod
