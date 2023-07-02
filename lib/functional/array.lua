--[[@class functional_array]]
local mod = {}

mod.array = function (arr)
	return setmetatable(arr, { __index = mod })
end

--[[@return integer]]
--[[@param arr unknown[] ]]
mod.size = function (arr) return #arr end

--[[@generic t]]
--[[@return t?]]
--[[@param arr t[] ]]
mod.first = function (arr) return arr[1] end

--[[@generic t]]
--[[@return t?]]
--[[@param arr t[] ]]
mod.last = function (arr) return arr[math.max(#arr - 1, 1)] end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param i? integer]]
--[[@param j? integer]]
mod.sub = function (arr, i, j)
	i = i or 1
	j = j or 1
	if j < 0 then j = #arr + j end
	local ret = {}
	for k = i, j do ret[#ret + 1] = arr[k] end
	return ret
end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param n integer]]
mod.skip = function (arr, n) return mod.sub(arr, n + 1, #arr) end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param n integer]]
mod.skip_last = function (arr, n) return mod.sub(arr, 1, math.max(0, #arr - n)) end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param n integer]]
mod.take = function (arr, n) return mod.sub(arr, 1, n) end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param n integer]]
mod.take_last = function (arr, n) return mod.sub(arr, math.max(1, #arr - n + 1), #arr) end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
mod.reverse = function (arr)
	local lenp1 = #arr + 1
	local ret = {}
	for i = 1, lenp1 - 1 do ret[lenp1 - i] = arr[i] end
	return ret
end

--[[@generic t]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param fn? fun(a: t, b: t): boolean]]
mod.sort = function (arr, fn)
	table.sort(arr, type(fn) == "table" and function (a, b) return fn(a, b) end or fn)
	return arr
end

local is_descending = { desc = true, descending = true, v = true, ["-"] = true }

--[[@generic t, u]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t): u]]
--[[@param direction "asc"|"desc"|"ascending"|"descending"|string?]]
mod.sort_by = function (arr, fn, direction)
	if is_descending[direction] or type(direction) == "number" and direction < 0 then table.sort(arr, function (a, b) return fn(a) > fn(b) end)
	else table.sort(arr, function (a, b) return fn(a) < fn(b) end) end
	return arr
end

--[[FIXME: flat_map, flat_map_i]]

--[[@generic t, u]]
--[[@return u[] ]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t): u]]
mod.map = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		ret[i] = fn(arr[i])
	end
	return mod.array(ret)
end

--[[@generic t, u]]
--[[@return u[] ]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, i: integer): u]]
mod.map_i = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		ret[i] = fn(arr[i], i)
	end
	return mod.array(ret)
end

--[[@generic t, u]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t): boolean]]
mod.filter = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		if fn(arr[i]) then ret[#ret+1] = arr[i] end
	end
	return mod.array(ret)
end

--[[@generic t, u]]
--[[@return t[]|functional_array]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, i: integer): boolean]]
mod.filter_i = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		if fn(arr[i], i) then ret[#ret+1] = arr[i] end
	end
	return mod.array(ret)
end

--[[@generic t, u]]
--[[@return u]]
--[[@param arr t[] ]]
--[[@param fn fun(acc: u, value: t): u]]
mod.fold = function (arr, fn, acc)
	for i = 1, #arr do acc = fn(acc, arr[i]) end
	return acc
end

--[[@generic t, u]]
--[[@return u]]
--[[@param arr t[] ]]
--[[@param fn fun(acc: u, value: t, i: integer): u]]
mod.fold_i = function (arr, fn, acc)
	for i = 1, #arr do acc = fn(acc, arr[i], i) end
	return acc
end

--[[@generic t]]
--[[@return t]]
--[[@param arr t[] ]]
--[[@param fn fun(acc: t, value: t): t]]
mod.fold1 = function (arr, fn)
	assert(#arr > 0, "fold1: arr must have at least one element")
	local acc = arr[1]
	for i = 2, #arr do acc = fn(acc, arr[i]) end
	return acc
end

--[[@generic t]]
--[[@return t]]
--[[@param arr t[] ]]
--[[@param fn fun(acc: t, value: t, i: integer): t]]
mod.fold1_i = function (arr, fn)
	assert(#arr > 0, "fold1_i: arr must have at least one element")
	local acc = arr[1]
	for i = 2, #arr do acc = fn(acc, arr[i], i) end
	return acc
end

--[[@generic t, u]]
--[[@return u]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, acc: u): u]]
mod.foldr = function (arr, fn, acc)
	for i = #arr, 1, -1 do acc = fn(arr[i], acc) end
	return acc
end

--[[@generic t, u]]
--[[@return u]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, acc: u, i: integer): u]]
mod.foldr_i = function (arr, fn, acc)
	for i = #arr, 1, -1 do acc = fn(arr[i], acc, i) end
	return acc
end

--[[@generic t]]
--[[@return t]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, acc: t): t]]
mod.foldr1 = function (arr, fn)
	assert(#arr > 0, "foldr1: arr must have at least one element")
	local acc = arr[#arr]
	for i = #arr - 1, 1, -1 do acc = fn(arr[i], acc) end
	return acc
end

--[[@generic t]]
--[[@return t]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, acc: t, i: integer): t]]
mod.foldr1_i = function (arr, fn)
	assert(#arr > 0, "foldr1_i: arr must have at least one element")
	local acc = arr[#arr]
	for i = #arr - 1, 1, -1 do acc = fn(arr[i], acc, i) end
	return acc
end

--[[@type fun(arr: (string|number)[]): string]]
mod.sjoin = table.concat

local func_iter

--[[@generic t]]
--[[@return (fun(): t?)|functional_iterable]]
--[[@param arr t[] ]]
mod.to_iter = function (arr)
	func_iter = func_iter or require("lib.functional.iterable")
	local i = 0
	return func_iter.iter(function ()
		if i >= #arr then return end; i = i + 1; return arr[i]
	end)
end

return mod
