local mod = {}

--[[https://github.com/ms-jpq/lua-async-await/blob/neo/README.md]]

mod.futurify = function (fn)
	return function (...)
		local params = { ... }
		local done = false
		return function (step)
			if done then return end
			params[#params+1] = step
			done = true
			fn(unpack(params))
		end
	end
end

mod.futurify_many = function (fn)
	return function (...)
		local params = { ... }
		local done = false
		--[[TODO: figure out how to end iteration]]
		local next = function (step)
			if done then return end
			params[#params+1] = step
			done = true
			fn(unpack(params))
		end
		return function () return next end
	end
end

--[[TODO: return yield() somehow?]]
mod.async = function (fn)
	return function (...)
		local args = { ... }
		return function (cb)
			local co = coroutine.create(fn)
			local step
			step = function (...)
				local _, cont = assert(coroutine.resume(co, ...))
				if coroutine.status(co) == "dead" then
					if cb then cb(cont) end
				else
					--[[@diagnostic disable-next-line: need-check-nil]]
					cont(step)
				end
			end
			step(unpack(args))
		end
	end
end

mod.await = coroutine.yield

mod.await_all = function(...)
	local fns = { ... }
	local vals = {}
	local left = #fns
	return mod.await(function (step)
		for i, fn in ipairs(fns) do
			fn(function (...)
				vals[i] = { ... }
				left = left - 1
				if left == 0 then
					step(unpack(vals))
				end
			end)
		end
	end)
end

mod.await_each = function (step, c, v)
	return function (c2, v2)
		local future = step(c2, v2)
		print("future", future)
		local ret = mod.await(future)
		print("ret", ret)
		return ret
	end, c, v
end

return mod
