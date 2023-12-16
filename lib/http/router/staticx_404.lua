local static_router = require("lib.http.router.staticx").static_router

local mod = {}

--[[@param base? string]]
mod.static_router = function (base)
	local router, err = static_router(base)
	if not router then return nil, err end
	return function (req, res)
		local ret = router(req, res)
		if not res.status or res.status == 404 then
			local path = req.path
			req.path = "/404.html"
			ret = router(req, res)
			req.path = path
		end
		return ret
	end
end

return mod
