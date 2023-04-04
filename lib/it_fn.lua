local mod = {}

local it_mt = {}

local fn_s = {}
local is_special = { [fn_s] = true }

local new_it = function (f)
	return setmetatable({ [fn_s] = f }, it_mt)
end

local bin_op = function (f)
	return function (self, other)
		if getmetatable(self) == it_mt then
			local g = self[fn_s]
			if getmetatable(other) == it_mt then
				local h = other[fn_s]
				return new_it(function (it) return f(g(it), h(it)) end)
			else return new_it(function (it) return f(g(it), other) end) end
		else
			local g = other[fn_s]
			return new_it(function (it) return f(self, g(it)) end)
		end
	end
end

mod.neg = function (self)
	local f = self[fn_s]
	return new_it(function (it) return -f(it) end)
end
mod.add = bin_op(function (a, b) return a + b end)
mod.sub = bin_op(function (a, b) return a - b end)
mod.mul = bin_op(function (a, b) return a * b end)
mod.div = bin_op(function (a, b) return a / b end)
mod.pow = bin_op(function (a, b) return a ^ b end)
mod.concat = bin_op(function (a, b) return a .. b end)
mod.eq = bin_op(function (a, b) return a == b end)
mod.ne = bin_op(function (a, b) return a ~= b end)
mod.lt = bin_op(function (a, b) return a < b end)
mod.gt = bin_op(function (a, b) return a > b end)
mod.le = bin_op(function (a, b) return a <= b end)
mod.ge = bin_op(function (a, b) return a >= b end)
mod.at = function (self, key)
	if is_special[key] then return rawget(self, key) end
	local f = self[fn_s]
	return new_it(function (it) return f(it)[key] end)
end

it_mt.__unm = mod.neg
it_mt.__add = mod.add
it_mt.__sub = mod.sub
it_mt.__mul = mod.mul
it_mt.__div = mod.div
it_mt.__pow = mod.pow
it_mt.__concat = mod.concat
it_mt.__index = mod.at

it_mt.__call = function (self, ...)
	return self[fn_s](...)
end

mod.it = new_it(function (it) return it end)

return mod
