local mod = {}

--[[@param ... fun(req: http_request, res: http_response): boolean ]]
mod.router = function (...)
	local routers = { ... }
	return function (req, res)
		for i = 1, #routers do
			local ret = routers[i](req, res)
			if ret then return ret end
		end
	end
end

return mod
