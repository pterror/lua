local ffi = require("ffi")
require("dep.glua.gl.gl3")

--[[@diagnostic disable: param-type-mismatch, assign-type-mismatch]]
--[[TODO: https://glm.g-truc.net/0.9.4/api/a00129.html]]
--[[TODO: optimize __index]]

ffi.cdef [[
typedef struct { double x, y; } vec2;
typedef struct { double x, y, z; } vec3;
typedef struct { double x, y, z, w; } vec4;
]]

local glFloatv = ffi.typeof("GLfloat[?]")

local vec2_vt = {}

--[[@class glua_vec2: ffi.ctype*]]
--[[@overload fun(a: number, b: number): glua_vec2]]
--[[@field x number]]
--[[@field y number]]
--[[@field gl number[] ]]
--[[@field length number]]
--[[@field normalize glua_vec2]]
--[[@field abs glua_vec2]]
--[[@field ceil glua_vec2]]
--[[@field floor glua_vec2]]
--[[@field min fun(self: glua_vec2, other: glua_vec2): glua_vec2]]
--[[@field max fun(self: glua_vec2, other: glua_vec2): glua_vec2]]
--[[@operator add: glua_vec2]]
--[[@operator sub: glua_vec2]]
--[[@operator mul: glua_vec2]]
--[[@operator div: glua_vec2]]
--[[@operator pow: glua_vec2 dot product]]
local vec2
--[[@type glua_vec2]]
vec2 = ffi.metatype("vec2", {
	--[[@param a glua_vec2]] --[[@param b glua_vec2]]
	__add = function (a, b) return vec2(a.x + b.x, a.y + b.y) end,
	--[[@param a glua_vec2]] --[[@param b glua_vec2]]
	__sub = function (a, b) return vec2(a.x - b.x, a.y - b.y) end,
	--[[@param a glua_vec2]] --[[@param b glua_vec2]]
	__mul = function (a, b)
		if not ffi.istype(vec2, b) then
		return vec2(a.x * b, a.y * b) end
		return vec2(a.x * b.x, a.y * b.y)
	end,
	--[[@param a glua_vec2]] --[[@param b glua_vec2]]
	__div = function (a, b)
		if not ffi.istype(vec2, b) then
		return vec2(a.x / b, a.y / b) end
		return vec2(a.x / b.x, a.y / b.y)
	end,
	--[[@param a glua_vec2]] --[[@param b glua_vec2]]
	__pow = function (a, b) --[[dot product]]
		if not ffi.istype(vec2, b) then
		return vec2(a.x ^ b, a.y ^ b) end
		return a.x * b.x + a.y * b.y
	end,
	--[[@param v glua_vec2]] --[[@param i string]]
	__index = function (v, i)
		if i == "gl" then return glFloatv(2, v.x, v.y)
		elseif i == "length" then return (v.x ^ 2 + v.y ^ 2) ^ 0.5
		elseif i == "normalize" then return v / v.length
		elseif i == "abs" then return vec2(math.abs(v.x), math.abs(v.y))
		elseif i == "ceil" then return vec2(math.ceil(v.x), math.ceil(v.y))
		elseif i == "floor" then return vec2(math.floor(v.x), math.floor(v.y))
		else return vec2_vt[i] end
	end,
	__tostring = function (v) return "<"..v.x..","..v.y..">" end
})

--[[@return glua_vec2]] --[[@param self glua_vec2]] --[[@param other glua_vec2]]
vec2_vt.min = function (self, other)
	return vec2(
		other.x < self.x and other.x or self.x,
		other.y < self.y and other.y or self.y
	)
end

--[[@return glua_vec2]] --[[@param self glua_vec2]] --[[@param other glua_vec2]]
vec2_vt.max = function (self, other)
	return vec2(
		self.x < other.x and other.x or self.x,
		self.y < other.y and other.y or self.y
	)
end

local vec3_vt = {}

--[[@class glua_vec3: ffi.ctype*]]
--[[@overload fun(a: number, b: number, c: number): glua_vec3]]
--[[@field x number]]
--[[@field y number]]
--[[@field z number]]
--[[@field gl number[] ]]
--[[@field length number]]
--[[@field normalize glua_vec3]]
--[[@field abs glua_vec3]]
--[[@field ceil glua_vec3]]
--[[@field floor glua_vec3]]
--[[@field min fun(self: glua_vec3, other: glua_vec3): glua_vec3]]
--[[@field max fun(self: glua_vec3, other: glua_vec3): glua_vec3]]
--[[@operator add: glua_vec3]]
--[[@operator sub: glua_vec3]]
--[[@operator mul: glua_vec3]]
--[[@operator div: glua_vec3]]
--[[@operator mod: glua_vec3 cross product]]
--[[@operator pow: glua_vec3 dot product]]
local vec3
--[[@type glua_vec3]]
vec3 = ffi.metatype("vec3", {
	--[[@param a glua_vec3]] --[[@param b glua_vec3]]
	__add = function (a, b) return vec3(a.x + b.x, a.y + b.y, a.z + b.z) end,
	--[[@param a glua_vec3]] --[[@param b glua_vec3]]
	__sub = function (a, b) return vec3(a.x - b.x, a.y - b.y, a.z - b.z) end,
	--[[@param a glua_vec3]] --[[@param b glua_vec3]]
	__mul = function (a, b)
		if not ffi.istype(vec3, b) then
		return vec3(a.x * b, a.y * b, a.z * b) end
		return vec3(a.x * b.x, a.y * b.y, a.z * b.z)
	end,
	--[[@param a glua_vec3]] --[[@param b glua_vec3]]
	__div = function (a, b)
		if not ffi.istype(vec3, b) then
		return vec3(a.x / b, a.y / b, a.z / b) end
		return vec3(a.x / b.x, a.y / b.y, a.z / b.z)
	end,
	--[[@param a glua_vec3]] --[[@param b glua_vec3]]
	__pow = function (a, b) --[[dot product]]
		if not ffi.istype(vec3, b) then
		return vec3(a.x ^ b, a.y ^ b, a.z ^ b) end
		return a.x * b.x + a.y * b.y + a.z * b.z
	end,
	--[[@param a glua_vec3]] --[[@param b glua_vec3]]
	__mod = function (a, b) --[[cross product]]
		return vec3(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
	end,
	--[[@param v glua_vec3]] --[[@param i string]]
	__index = function (v, i)
		if i == "gl" then return glFloatv(3, v.x, v.y, v.z)
		elseif i == "length" then return (v.x ^ 2 + v.y ^ 2 + v.z ^ 2) ^ 0.5
		elseif i == "normalize" then return v / v.length
		elseif i == "abs" then return vec3(math.abs(v.x), math.abs(v.y), math.abs(v.z))
		elseif i == "ceil" then return vec3(math.ceil(v.x), math.ceil(v.y), math.ceil(v.z))
		elseif i == "floor" then return vec3(math.floor(v.x), math.floor(v.y), math.floor(v.z))
		else return vec3_vt[i] end
	end,
	__tostring = function (v) return "<"..v.x..","..v.y..","..v.z..">" end
})

--[[@return glua_vec3]] --[[@param self glua_vec3]] --[[@param other glua_vec3]]
vec3_vt.min = function (self, other)
	return vec3(
		other.x < self.x and other.x or self.x,
		other.y < self.y and other.y or self.y,
		other.z < self.z and other.z or self.z
	)
end

--[[@return glua_vec3]] --[[@param self glua_vec3]] --[[@param other glua_vec3]]
vec3_vt.max = function (self, other)
	return vec3(
		self.x < other.x and other.x or self.x,
		self.y < other.y and other.y or self.y,
		self.z < other.z and other.z or self.z
	)
end

local vec4_vt = {}

--[[@class glua_vec4: ffi.ctype*]]
--[[@overload fun(a: number, b: number, c: number, d: number): glua_vec4]]
--[[@field x number]]
--[[@field y number]]
--[[@field z number]]
--[[@field w number]]
--[[@field gl number[] ]]
--[[@field length number]]
--[[@field normalize glua_vec4]]
--[[@field abs glua_vec4]]
--[[@field ceil glua_vec4]]
--[[@field floor glua_vec4]]
--[[@field min fun(self: glua_vec4, other: glua_vec4): glua_vec4]]
--[[@field max fun(self: glua_vec4, other: glua_vec4): glua_vec4]]
--[[@operator add: glua_vec4]]
--[[@operator sub: glua_vec4]]
--[[@operator mul: glua_vec4]]
--[[@operator div: glua_vec4]]
--[[@operator pow: glua_vec4]]
local vec4
--[[@type glua_vec4]]
vec4 = ffi.metatype("vec4", {
	--[[@param a glua_vec4]] --[[@param b glua_vec4]]
	__add = function (a, b) return vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w) end,
	--[[@param a glua_vec4]] --[[@param b glua_vec4]]
	__sub = function (a, b) return vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w) end,
	--[[@param a glua_vec4]] --[[@param b glua_vec4]]
	__mul = function (a, b)
		if not ffi.istype(vec4, b) then
		return vec4(a.x * b, a.y * b, a.z * b, a.w * b) end
		return vec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
	end,
	--[[@param a glua_vec4]] --[[@param b glua_vec4]]
	__div = function (a, b)
		if not ffi.istype(vec4, b) then
		return vec4(a.x / b, a.y / b, a.z / b, a.w / b) end
		return vec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
	end,
	--[[@param a glua_vec4]] --[[@param b glua_vec4]]
	__pow = function (a, b) -- dot product
		if not ffi.istype(vec4, b) then
		return vec4(a.x ^ b, a.y ^ b, a.z ^ b, a.w ^ b) end
		return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
	end,
	--[[@param v glua_vec4]] --[[@param i string]]
	__index = function (v, i)
		if i == "gl" then return glFloatv(4, v.x, v.y, v.z, v.w)
		elseif i == "length" then return (v.x ^ 2 + v.y ^ 2 + v.z ^ 2 + v.w ^ 2) ^ 0.5
		elseif i == "normalize" then return v / v.length
		elseif i == "abs" then return vec4(math.abs(v.x), math.abs(v.y), math.abs(v.z), math.abs(v.w))
		elseif i == "ceil" then return vec4(math.ceil(v.x), math.ceil(v.y), math.ceil(v.z), math.ceil(v.w))
		elseif i == "floor" then return vec4(math.floor(v.x), math.floor(v.y), math.floor(v.z), math.floor(v.w))
		else return vec4_vt[i] end
	end,
	__tostring = function (v) return "<"..v.x..","..v.y..","..v.z..","..v.w..">" end
})

--[[@return glua_vec4]] --[[@param self glua_vec4]] --[[@param other glua_vec4]]
vec4_vt.min = function (self, other)
	return vec4(
		other.x < self.x and other.x or self.x,
		other.y < self.y and other.y or self.y,
		other.z < self.z and other.z or self.z,
		other.w < self.w and other.w or self.w
	)
end

--[[@return glua_vec4]] --[[@param self glua_vec4]] --[[@param other glua_vec4]]
vec4_vt.max = function (self, other)
	return vec4(
		self.x < other.x and other.x or self.x,
		self.y < other.y and other.y or self.y,
		self.z < other.z and other.z or self.z,
		self.w < other.w and other.w or self.w
	)
end

return {
	vec2 = vec2, vec3 = vec3, vec4 = vec4, vec = vec4,
	vec2_vt = vec2_vt, vec3_vt = vec3_vt, vec4_vt = vec4_vt,
	vvec2 = ffi.typeof("vec2[?]"),
	vvec3 = ffi.typeof("vec3[?]"),
	vvec4 = ffi.typeof("vec4[?]"),
	vvec  = ffi.typeof("vec4[?]")
}
