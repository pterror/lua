local mod = {}

--[[@generic t, u]]
--[[@return fun(): u?]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t): u]]
mod.map = function (iter, fn)
	return function ()
		local val = iter()
		return val ~= nil and fn(val) or val
	end
end

--[[@generic t, u]]
--[[@return fun(): t?]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t): boolean]]
mod.filter = function (iter, fn)
	return function ()
		local val = iter()
		while val ~= nil and not fn(val) do val = iter() end
		return val
	end
end

--[[@generic t, u]]
--[[@return u]]
--[[@param iter fun(): t?]]
--[[@param fn fun(acc: u, value: t): u]]
mod.fold = function (iter, fn, acc)
	local val = iter()
	while val ~= nil do acc = fn(acc, val); val = iter() end
	return acc
end

--[[@generic t]]
--[[@return t]]
--[[@param iter fun(): t?]]
--[[@param fn fun(acc: t, value: t): t]]
mod.fold1 = function (iter, fn)
	local acc = iter()
	assert(acc ~= nil, "fold1: iter must have at least one element")
	local val = iter()
	while val ~= nil do acc = fn(acc, val); val = iter() end
	return acc
end

return mod
