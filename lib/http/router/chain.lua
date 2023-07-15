local mod = {}

--[[@param ... (fun(req: http_request, res: http_response): boolean)[] ]]
mod.chain_router = function (...)
	local routers = { ... }
	return function (req, res)
		for i = 1, #routers do
			local router = routers[i]
			local ret = router(req, res)
			if ret then return ret end
		end
	end
end

return mod
