local mod = {}

local it_mt = {}

local is_literal_type = {
	["nil"] = true, number = true, boolean = true,
}

local str_s = {}
local vars_s = {}
local fn_s = {}
local is_special = { [str_s] = true, [vars_s] = true, [fn_s] = true }

local uneval = function (self, x)
	if getmetatable(x) == it_mt then
		local offset = #self[vars_s]
		for i = 1, #x[vars_s] do self[vars_s][offset + i] = x[vars_s][i] end
		if offset ~= 0 then return x[str_s]:gsub(" vars[(%d+)]", function (y) return (" vars[%s]"):format(tonumber(y) + offset) end)
		else return x[str_s] end
	elseif is_literal_type[type(x)] then return tostring(x)
	else self[vars_s][#self[vars_s]+1] = x; return (" vars[%s]"):format(#self[vars_s]) end
end

--[[@param s string]]
local new_it = function (s)
	return setmetatable({ [str_s] = s, [vars_s] = {}, [fn_s] = nil }, it_mt)
end

local un_op = function (op)
	return function (self)
		local new_it_ = new_it("")
		new_it_[str_s] = ("%s(%s)"):format(op, uneval(new_it_, self))
		return new_it_
	end
end

local bin_op = function (op)
	return function (self, other)
		local new_it_ = new_it("")
		new_it_[str_s] = ("(%s) %s (%s)"):format(uneval(new_it_, self), op, uneval(new_it_, other))
		return new_it_
	end
end

mod.neg = un_op("-")
mod.and_ = bin_op("and")
mod.or_ = bin_op("or")
mod.add = bin_op("+")
mod.sub = bin_op("-")
mod.mul = bin_op("*")
mod.div = bin_op("/")
mod.pow = bin_op("^")
mod.concat = bin_op("..")
mod.eq = bin_op("==")
mod.ne = bin_op("~=")
mod.lt = bin_op("<")
mod.gt = bin_op(">")
mod.le = bin_op("<=")
mod.ge = bin_op(">=")
mod.at = function (self, key)
	if is_special[key] then return rawget(self, key) end
	local new_it_ = new_it("")
	new_it_[str_s] = ("(%s)[%s]"):format(uneval(new_it_, self), uneval(new_it_, key))
	return new_it_
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
	self[fn_s] = self[fn_s] or loadstring(("return function (vars) return function (it) return %s end end"):format(self[str_s]))()(self[vars_s])
	return self[fn_s](...)
end
it_mt.__tostring = function () return "<it object>" end

mod.it = new_it("it")

return mod
