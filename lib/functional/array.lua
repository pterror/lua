--[[@class functional_array]]
local mod = {}

mod.array = function (arr)
	return setmetatable(arr, { __index = mod })
end

--[[@generic t]]
--[[@return t[] ]]
--[[@param arr t[] ]]
--[[@param fn? fun(a: t, b: t): boolean]]
mod.sort = function (arr, fn)
	table.sort(arr, type(fn) == "table" and function (a, b) return fn(a, b) end or fn)
	return arr
end

--[[@generic t, u]]
--[[@return t[] ]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t): u]]
mod.sort_by = function (arr, fn)
	table.sort(arr, function (a, b) return fn(a) < fn(b) end)
	return arr
end

--[[@generic t, u]]
--[[@return u[] ]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t): u]]
mod.map = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		ret[i] = fn(arr[i])
	end
	return ret
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
	return ret
end

--[[@generic t, u]]
--[[@return t[] ]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t): boolean]]
mod.filter = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		if fn(arr[i]) then ret[#ret+1] = arr[i] end
	end
	return ret
end

--[[@generic t, u]]
--[[@return t[] ]]
--[[@param arr t[] ]]
--[[@param fn fun(value: t, i: integer): boolean]]
mod.filter_i = function (arr, fn)
	local ret = {}
	for i = 1, #arr do
		if fn(arr[i], i) then ret[#ret+1] = arr[i] end
	end
	return ret
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

return mod
