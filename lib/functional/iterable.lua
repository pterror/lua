--[[@class functional_iterable]]
local mod = {}

local call_iter = function (self)
	return self.fn(self.state, self.index)
end

local mt = { __index = mod, __call = call_iter }

mod.is_iter = function (iter) return type(iter) == "table" and getmetatable(iter) == mt end

--[[@generic t]]
--[[@return (fun(): t?)|functional_iterable]]
--[[@param iter fun(): t?]]
mod.iter = function (iter, state, index)
	--[[@diagnostic disable-next-line: return-type-mismatch]]
	return setmetatable({ fn = iter, state = state, index = index }, mt)
end

--[[@return integer]]
--[[@param iter fun(): unknown?]]
mod.size = function (iter)
	local size = 0
	for _ in iter do size = size + 1 end
	return size
end

--[[@generic t]]
--[[@return t?]]
--[[@param iter fun(): t?]]
mod.first = function (iter) return iter() end

--[[@generic t]]
--[[@return (fun(): t?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param count integer]]
mod.skip = function (iter, count)
	count = count or 1
	for _ = 1, count do iter() end
	return iter
end

--[[@generic t]]
--[[@return (fun(): t?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param count integer]]
mod.take = function (iter, count)
	count = count or 1
	return mod.iter(function ()
		if count > 0 then count = count - 1; return iter() end
	end)
end

--[[@generic t, u]]
--[[@return (fun(): u?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t): u]]
mod.map = function (iter, fn)
	return mod.iter(function ()
		local val = iter()
		return val ~= nil and fn(val) or val
	end)
end

--[[this behaves differently from `array:map`. this is necessary as returning `nil` stops the iterator]]
mod.each = mod.map

--[[@generic t, u]]
--[[@return (fun(): u?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t, i: integer): u]]
mod.map_i = function (iter, fn)
	local i = 0
	return mod.iter(function ()
		local val = iter()
		if val ~= nil then i = i + 1; return fn(val, i) end
	end)
end

mod.each_i = mod.map_i

--[[@generic t, u]]
--[[@return (fun(): u?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t): fun(): u?]]
mod.flat_map = function (iter, fn)
	local inner_iter = nil
	local finished = false
	return mod.iter(function ()
		if finished then return nil end
		if inner_iter == nil then
			local val = iter()
			if val == nil then finished = true; return end
			inner_iter = fn(val)
		end
		local val = inner_iter()
		while val == nil and inner_iter ~= nil do
			inner_iter = iter()
			val = inner_iter()
		end
		return val
	end)
end

--[[@generic t, u]]
--[[@return (fun(): u?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t, i: integer): fun(): u?]]
mod.flat_map_i = function (iter, fn)
	local inner_iter = nil
	local finished = false
	local i = 0
	return mod.iter(function ()
		if finished then return nil end
		if inner_iter == nil then
			local val = iter()
			if val == nil then finished = true; return end
			i = i + 1
			inner_iter = fn(val, i)
		end
		local val = inner_iter()
		while val == nil and inner_iter ~= nil do
			inner_iter = iter()
			val = inner_iter()
		end
		return val
	end)
end

--[[@generic t, u]]
--[[@return (fun(): t?)|functional_iterable]]
--[[@param iter fun(): t?]]
--[[@param fn fun(value: t): boolean]]
mod.filter = function (iter, fn)
	return mod.iter(function ()
		local val = iter()
		while val ~= nil and not fn(val) do val = iter() end
		return val
	end)
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

--[[@return (fun(): integer?)|functional_iterable]]
--[[@param start integer]] --[[@param stop integer]] --[[@param step? integer]]
mod.range = function (start, stop, step)
	if step == 0 then error("iter.range: step cannot be 0") end
	step = step or (start <= stop and 1 or -1)
	if (start < stop and step < 0) or (start > stop and step > 0) then
		error("iter.range: step is going in the wrong direction")
	end
	local current = start - step
	return mod.iter(step >= 0 and function ()
		current = current + step
		if current <= stop then return current end
	end or function ()
		current = current + step
		if current >= stop then return current end
	end)
end

local func_arr

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param iter fun(): t?]]
mod.to_array = function (iter)
	func_arr = func_arr or require("lib.functional.array")
	local arr = {}
	for val in iter do arr[#arr + 1] = val end
	return func_arr.array(arr)
end

mod.to_a = mod.to_array

local arrayize = function (key)
	return function (iter, ...)
		func_arr = func_arr or require("lib.functional.array")
		return func_arr["key"](mod.to_array(iter), ...)
	end
end

--[[@generic t]]
--[[@type fun(iter: (fun(): t?), fn: (fun(a: t, b: t): boolean)?): t[]|functional_array]]
mod.sort = arrayize("sort")
--[[@generic t, u]]
--[[@return t[] ]]
--[[@type fun(iter: (fun(): t?), fn: (fun(value: t): u), direction: "asc"|"desc"|"ascending"|"descending"|string?): t[]|functional_array]]
mod.sort_by = arrayize("sort_by")
--[[@generic t, u]]
--[[@type fun(iter: (fun(): t?), fn: (fun(value: t, acc: u): u)): u]]
mod.foldr = arrayize("foldr")
--[[@generic t, u]]
--[[@type fun(iter: (fun(): t?), fn: (fun(value: t, acc: u, i: integer): u)): u]]
mod.foldr_i = arrayize("foldr_i")
--[[@generic t]]
--[[@type fun(iter: (fun(): t?), fn: (fun(value: t, acc: t): t)): t]]
mod.foldr1 = arrayize("foldr1")
--[[@generic t]]
--[[@type fun(iter: (fun(): t?), fn: (fun(value: t, acc: t, i: integer): t)): t[]|functional_array]]
mod.foldr1_i = arrayize("foldr1_i")
--[[@generic t]]
--[[@type fun(iter: (fun(): t?)): t?]]
mod.last = arrayize("last")
--[[@generic t]]
--[[@type fun(iter: (fun(): t?), n: integer): t[]|functional_array]]
mod.take_last = arrayize("take_last")

--[[@type fun(iter: (fun(): (string|number)?)): string]]
mod.sjoin = arrayize("sjoin")

return mod
