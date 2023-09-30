local ffi = require("ffi")
require("dep.glua.gl.gl3")
local math = require("math")
local sin, cos = math.sin, math.cos

--[[@diagnostic disable: param-type-mismatch, assign-type-mismatch]]

ffi.cdef [[
typedef struct {
	double m11, m21;
	double m12, m22;
} mat2;
typedef struct {
	double m11, m21, m31;
	double m12, m22, m32;
	double m13, m23, m33;
} mat3;
typedef struct {
	double m11, m21, m31, m41;
	double m12, m22, m32, m42;
	double m13, m23, m33, m43;
	double m14, m24, m34, m44;
} mat4;
typedef struct { double w; double x; double y; double z; } quat;
]]

local mod = require("dep.glua.vector")

local vec2, vec3, vec4 = mod.vec2, mod.vec3, mod.vec4

local glFloatv = ffi.typeof("GLfloat[?]")

--[[@class glua_mat2: ffi.ctype*]]
--[[@overload fun(m11: number, m21: number, m12: number, m22: number): glua_mat2]]
--[[@field m11 number]]
--[[@field m21 number]]
--[[@field m12 number]]
--[[@field m22 number]]
--[[@field t glua_mat2]]
--[[@field det number]]
--[[@field inv glua_mat2]]
--[[@field gl number[] ]]
--[[@operator mul(glua_mat2): glua_mat2]]
--[[@operator mul(glua_vec2): glua_vec2]]
--[[@operator mul(number): glua_mat2]]
local mat2
--[[@type glua_mat2]]
mat2 = ffi.metatype("mat2", {
	__mul = function (a, b)
		if not ffi.istype(mat2, a) then a, b = b, a end
		if ffi.istype(mat2, b) then
			return mat2(a.m11*b.m11 + a.m21*b.m12,  a.m11*b.m21 + a.m21*b.m22,
									a.m12*b.m11 + a.m22*b.m12,  a.m12*b.m21 + a.m22*b.m22)
		elseif ffi.istype(vec2, b) then
			return vec2(a.m11*b.x + a.m21*b.y,
									a.m12*b.x + a.m22*b.y)
		end
		return mat2(a.m11 * b, a.m21 * b,
								a.m12 * b, a.m22 * b)
	end,
	__index = function (m, i)
		if i == "t" then
			return mat2(m.m11, m.m12,
									m.m21, m.m22)
		elseif i == "det" then
			return m.m11 * m.m22 - m.m21 * m.m12
		elseif i == "inv" then
			local det = m.m11 * m.m22 - m.m21 * m.m12;
			return mat2( m.m22 / det, -m.m21 / det,
									-m.m12 / det,  m.m11 / det)
		elseif i == "gl" then
			return glFloatv(4, m.m11, m.m21,
												 m.m12, m.m22)
		end
	end,
	__tostring = function (m)
		return string.format(
			"[%4.1f %4.1f]\n[%4.1f %4.1f]",
			m.m11, m.m21,   m.m12, m.m22
		)
	end,
})

--[[@class glua_mat3: ffi.ctype*]]
--[[@overload fun(m11: number, m21: number, m31: number, m12: number, m22: number, m32: number, m13: number, m23: number, m33: number): glua_mat3]]
--[[@field m11 number]]
--[[@field m21 number]]
--[[@field m31 number]]
--[[@field m12 number]]
--[[@field m22 number]]
--[[@field m32 number]]
--[[@field m13 number]]
--[[@field m23 number]]
--[[@field m33 number]]
--[[@field mat2 glua_mat2]]
--[[@field t glua_mat3]]
--[[@field det number]]
--[[@field inv glua_mat3]]
--[[@field gl number[] ]]
--[[@operator mul(glua_mat3): glua_mat3]]
--[[@operator mul(glua_vec3): glua_vec3]]
--[[@operator mul(number): glua_mat3]]
local mat3
--[[@type glua_mat3]]
mat3 = ffi.metatype("mat3", {
	__mul = function (a, b)
		if not ffi.istype(mat3, a) then a, b = b, a end
		if ffi.istype(mat3, b) then
			return mat3(
				a.m11*b.m11 + a.m21*b.m12 + a.m31*b.m13,  a.m11*b.m21 + a.m21*b.m22 + a.m31*b.m23,  a.m11*b.m31 + a.m21*b.m32 + a.m31*b.m33,
				a.m12*b.m11 + a.m22*b.m12 + a.m32*b.m13,  a.m12*b.m21 + a.m22*b.m22 + a.m32*b.m23,  a.m12*b.m31 + a.m22*b.m32 + a.m32*b.m33,
				a.m13*b.m11 + a.m23*b.m12 + a.m33*b.m13,  a.m13*b.m21 + a.m23*b.m22 + a.m33*b.m23,  a.m13*b.m31 + a.m23*b.m32 + a.m33*b.m33
			)
			--[[@diagnostic disable-next-line: param-type-mismatch]]
		elseif ffi.istype(vec3, b) then
			return vec3(
				a.m11*b.x + a.m21*b.y + a.m31*b.z,
				a.m12*b.x + a.m22*b.y + a.m32*b.z,
				a.m13*b.x + a.m23*b.y + a.m33*b.z
			)
		end
		return mat3(
			a.m11 * b, a.m21 * b, a.m31 * b,
			a.m12 * b, a.m22 * b, a.m32 * b,
			a.m13 * b, a.m23 * b, a.m33 * b
		)
	end,
	__index = function (m, i)
		if i == "mat2" then
			return mat2(
				m.m11, m.m21,
				m.m12, m.m22
			)
		elseif i == "t" then
			return mat3(
				m.m11, m.m12, m.m13,
				m.m21, m.m22, m.m23,
				m.m31, m.m32, m.m33
			)
		elseif i == "det" then
			return m.m11 * (m.m22*m.m33 - m.m32*m.m23) +
				m.m21 * (m.m32*m.m13 - m.m33*m.m12) +
				m.m31 * (m.m12*m.m23 - m.m22*m.m13)
		elseif i == "inv" then
			local det = m.m11 * (m.m22*m.m33 - m.m32*m.m23) +
				m.m21 * (m.m32*m.m13 - m.m33*m.m12) +
				m.m31 * (m.m12*m.m23 - m.m22*m.m13)
			return mat3(
				(m.m22*m.m33 - m.m32*m.m23) / det, (m.m31*m.m23 - m.m21*m.m33) / det, (m.m21*m.m32 - m.m31*m.m22) / det,
				(m.m32*m.m13 - m.m12*m.m33) / det, (m.m11*m.m33 - m.m31*m.m13) / det, (m.m31*m.m12 - m.m11*m.m32) / det,
				(m.m12*m.m23 - m.m22*m.m13) / det, (m.m13*m.m21 - m.m11*m.m23) / det, (m.m11*m.m22 - m.m21*m.m12) / det
			)
		elseif i == "gl" then
			return glFloatv(9,
				m.m11, m.m21, m.m31,
				m.m12, m.m22, m.m32,
				m.m13, m.m23, m.m33
			)
		end
	end,
	__tostring = function (m)
		return string.format(
			"[%4.1f %4.1f %4.1f]\n[%4.1f %4.1f %4.1f]\n[%4.1f %4.1f %4.1f]",
			m.m11, m.m21, m.m31,  m.m12, m.m22, m.m32,  m.m13, m.m23, m.m33
		)
	end,
})

--[[@class glua_mat4: ffi.ctype*]]
--[[@overload fun(m11: number, m21: number, m31: number, m41: number, m12: number, m22: number, m32: number, m42: number, m13: number, m23: number, m33: number, m43: number, m14: number, m24: number, m34: number, m44: number): glua_mat4]]
--[[@field m11 number]]
--[[@field m21 number]]
--[[@field m31 number]]
--[[@field m41 number]]
--[[@field m12 number]]
--[[@field m22 number]]
--[[@field m32 number]]
--[[@field m42 number]]
--[[@field m13 number]]
--[[@field m23 number]]
--[[@field m33 number]]
--[[@field m43 number]]
--[[@field m14 number]]
--[[@field m24 number]]
--[[@field m34 number]]
--[[@field m44 number]]
--[[@field mat3 glua_mat3]]
--[[@field mat2 glua_mat2]]
--[[@field t glua_mat4]]
--[[@field det number]]
--[[@field inv glua_mat4]]
--[[@field gl number[] ]]
--[[@operator mul(glua_mat4): glua_mat4]]
--[[@operator mul(glua_vec4): glua_vec4]]
--[[@operator mul(glua_vec3): glua_vec3]]
--[[@operator mul(number): glua_mat4]]
local mat4
--[[@type glua_mat4]]
mat4 = ffi.metatype("mat4", {
	__mul = function (a, b)
		if not ffi.istype(mat4, a) then a, b = b, a end
		if ffi.istype(mat4, b) then
			local ret = mat4(
				a.m11*b.m11 + a.m21*b.m12 + a.m31*b.m13 + a.m41*b.m14,
				a.m11*b.m21 + a.m21*b.m22 + a.m31*b.m23 + a.m41*b.m24,
				a.m11*b.m31 + a.m21*b.m32 + a.m31*b.m33 + a.m41*b.m34,
				a.m11*b.m41 + a.m21*b.m42 + a.m31*b.m43 + a.m41*b.m44,

				a.m12*b.m11 + a.m22*b.m12 + a.m32*b.m13 + a.m42*b.m14,
				a.m12*b.m21 + a.m22*b.m22 + a.m32*b.m23 + a.m42*b.m24,
				a.m12*b.m31 + a.m22*b.m32 + a.m32*b.m33 + a.m42*b.m34,
				a.m12*b.m41 + a.m22*b.m42 + a.m32*b.m43 + a.m42*b.m44,

				a.m13*b.m11 + a.m23*b.m12 + a.m33*b.m13 + a.m43*b.m14,
				a.m13*b.m21 + a.m23*b.m22 + a.m33*b.m23 + a.m43*b.m24,
				a.m13*b.m31 + a.m23*b.m32 + a.m33*b.m33 + a.m43*b.m34,
				a.m13*b.m41 + a.m23*b.m42 + a.m33*b.m43 + a.m43*b.m44,

				a.m14*b.m11 + a.m24*b.m12 + a.m34*b.m13 + a.m44*b.m14,
				a.m14*b.m21 + a.m24*b.m22 + a.m34*b.m23 + a.m44*b.m24,
				a.m14*b.m31 + a.m24*b.m32 + a.m34*b.m33 + a.m44*b.m34,
				a.m14*b.m41 + a.m24*b.m42 + a.m34*b.m43 + a.m44*b.m44)
			return ret
		--[[@diagnostic disable-next-line: param-type-mismatch]]
		elseif ffi.istype(vec4, b) then
			return vec4(
				a.m11*b.x + a.m21*b.y + a.m31*b.z + a.m41*b.w,
				a.m12*b.x + a.m22*b.y + a.m32*b.z + a.m42*b.w,
				a.m13*b.x + a.m23*b.y + a.m33*b.z + a.m43*b.w,
				a.m14*b.x + a.m24*b.y + a.m34*b.z + a.m44*b.w)
				--[[@diagnostic disable-next-line: param-type-mismatch]]
		elseif ffi.istype(vec3, b) then
			return vec3(
				a.m11*b.x + a.m21*b.y + a.m31*b.z + a.m41*b.w,
				a.m12*b.x + a.m22*b.y + a.m32*b.z + a.m42*b.w,
				a.m13*b.x + a.m23*b.y + a.m33*b.z + a.m43*b.w)
		end
		return mat4(
			a.m11*b, a.m21*b, a.m31*b, a.m41*b,
			a.m12*b, a.m22*b, a.m32*b, a.m42*b,
			a.m13*b, a.m23*b, a.m33*b, a.m43*b,
			a.m14*b, a.m24*b, a.m34*b, a.m44*b)
	end,
	__index = function (m, i)
		if i == "mat3" then
			return mat3(m.m11, m.m21, m.m31,
									m.m12, m.m22, m.m32,
									m.m13, m.m23, m.m33)
		elseif i == "mat2" then
			return mat2(m.m11, m.m21,
									m.m12, m.m22)
		elseif i == "t" then
			return mat4(m.m11, m.m12, m.m13, m.m14,
									m.m21, m.m22, m.m23, m.m24,
									m.m31, m.m32, m.m33, m.m34,
									m.m41, m.m42, m.m43, m.m44)
		-- http://stackoverflow.com/questions/1148309/inverting-a-4x4-matrix
		elseif i == "det" then
			local i1 =  m.m22*m.m33*m.m44 - m.m22*m.m43*m.m34 - m.m23*m.m32*m.m44 + m.m23*m.m42*m.m34 + m.m24*m.m32*m.m43 - m.m24*m.m42*m.m33
			local i2 = -m.m12*m.m33*m.m44 + m.m12*m.m43*m.m34 + m.m13*m.m32*m.m44 - m.m13*m.m42*m.m34 - m.m14*m.m32*m.m43 + m.m14*m.m42*m.m33
			local i3 =  m.m12*m.m23*m.m44 - m.m12*m.m43*m.m24 - m.m13*m.m22*m.m44 + m.m13*m.m42*m.m24 + m.m14*m.m22*m.m43 - m.m14*m.m42*m.m23
			local i4 = -m.m12*m.m23*m.m34 + m.m12*m.m33*m.m24 + m.m13*m.m22*m.m34 - m.m13*m.m32*m.m24 - m.m14*m.m22*m.m33 + m.m14*m.m32*m.m23
			return m.m11*i1 + m.m21*i2 + m.m31*i3 + m.m41*i4
		elseif i == "inv" then
			local inv = mat4(
				m.m22*m.m33*m.m44 - m.m22*m.m43*m.m34 - m.m23*m.m32*m.m44 + m.m23*m.m42*m.m34 + m.m24*m.m32*m.m43 - m.m24*m.m42*m.m33,
			 -m.m21*m.m33*m.m44 + m.m21*m.m43*m.m34 + m.m23*m.m31*m.m44 - m.m23*m.m41*m.m34 - m.m24*m.m31*m.m43 + m.m24*m.m41*m.m33,
				m.m21*m.m32*m.m44 - m.m21*m.m42*m.m34 - m.m22*m.m31*m.m44 + m.m22*m.m41*m.m34 + m.m24*m.m31*m.m42 - m.m24*m.m41*m.m32,
			 -m.m21*m.m32*m.m43 + m.m21*m.m42*m.m33 + m.m22*m.m31*m.m43 - m.m22*m.m41*m.m33 - m.m23*m.m31*m.m42 + m.m23*m.m41*m.m32,
			 -m.m12*m.m33*m.m44 + m.m12*m.m43*m.m34 + m.m13*m.m32*m.m44 - m.m13*m.m42*m.m34 - m.m14*m.m32*m.m43 + m.m14*m.m42*m.m33,
				m.m11*m.m33*m.m44 - m.m11*m.m43*m.m34 - m.m13*m.m31*m.m44 + m.m13*m.m41*m.m34 + m.m14*m.m31*m.m43 - m.m14*m.m41*m.m33,
			 -m.m11*m.m32*m.m44 + m.m11*m.m42*m.m34 + m.m12*m.m31*m.m44 - m.m12*m.m41*m.m34 - m.m14*m.m31*m.m42 + m.m14*m.m41*m.m32,
				m.m11*m.m32*m.m43 - m.m11*m.m42*m.m33 - m.m12*m.m31*m.m43 + m.m12*m.m41*m.m33 + m.m13*m.m31*m.m42 - m.m13*m.m41*m.m32,
				m.m12*m.m23*m.m44 - m.m12*m.m43*m.m24 - m.m13*m.m22*m.m44 + m.m13*m.m42*m.m24 + m.m14*m.m22*m.m43 - m.m14*m.m42*m.m23,
			 -m.m11*m.m23*m.m44 + m.m11*m.m43*m.m24 + m.m13*m.m21*m.m44 - m.m13*m.m41*m.m24 - m.m14*m.m21*m.m43 + m.m14*m.m41*m.m23,
				m.m11*m.m22*m.m44 - m.m11*m.m42*m.m24 - m.m12*m.m21*m.m44 + m.m12*m.m41*m.m24 + m.m14*m.m21*m.m42 - m.m14*m.m41*m.m22,
			 -m.m11*m.m22*m.m43 + m.m11*m.m42*m.m23 + m.m12*m.m21*m.m43 - m.m12*m.m41*m.m23 - m.m13*m.m21*m.m42 + m.m13*m.m41*m.m22,
			 -m.m12*m.m23*m.m34 + m.m12*m.m33*m.m24 + m.m13*m.m22*m.m34 - m.m13*m.m32*m.m24 - m.m14*m.m22*m.m33 + m.m14*m.m32*m.m23,
				m.m11*m.m23*m.m34 - m.m11*m.m33*m.m24 - m.m13*m.m21*m.m34 + m.m13*m.m31*m.m24 + m.m14*m.m21*m.m33 - m.m14*m.m31*m.m23,
			 -m.m11*m.m22*m.m34 + m.m11*m.m32*m.m24 + m.m12*m.m21*m.m34 - m.m12*m.m31*m.m24 - m.m14*m.m21*m.m32 + m.m14*m.m31*m.m22,
				m.m11*m.m22*m.m33 - m.m11*m.m32*m.m23 - m.m12*m.m21*m.m33 + m.m12*m.m31*m.m23 + m.m13*m.m21*m.m32 - m.m13*m.m31*m.m22)
			 local det = m.m11*inv.m11 + m.m21*inv.m12 + m.m31*inv.m13 + m.m41*inv.m14
			 inv.m11 = inv.m11 / det; inv.m21 = inv.m21 / det; inv.m31 = inv.m31 / det; inv.m41 = inv.m41 / det
			 inv.m12 = inv.m12 / det; inv.m22 = inv.m22 / det; inv.m32 = inv.m32 / det; inv.m42 = inv.m42 / det
			 inv.m13 = inv.m13 / det; inv.m23 = inv.m23 / det; inv.m33 = inv.m33 / det; inv.m43 = inv.m43 / det
			 inv.m14 = inv.m14 / det; inv.m24 = inv.m24 / det; inv.m34 = inv.m34 / det; inv.m44 = inv.m44 / det
			 return inv
		elseif i == "gl" then
			return glFloatv(16,
				m.m11, m.m21, m.m31, m.m41,
				m.m12, m.m22, m.m32, m.m42,
				m.m13, m.m23, m.m33, m.m43,
				m.m14, m.m24, m.m34, m.m44
			)
		end
	end,
	__tostring = function (m)
		return string.format(
			"[%4.1f %4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f %4.1f ]\n[%4.1f %4.1f %4.1f %4.1f ]",
			m.m11, m.m21, m.m31, m.m41, m.m12, m.m22, m.m32, m.m42, m.m13, m.m23, m.m33, m.m43, m.m14, m.m24, m.m34, m.m44
		)
	end,
})

--[[@class glua_quat: ffi.ctype*]]
--[[@overload fun(w: number, x: number, y: number, z: number): glua_quat]]
--[[@field w number]]
--[[@field x number]]
--[[@field y number]]
--[[@field z number]]
--[[@field mat3 glua_mat3]]
--[[@field mat4 glua_mat4]]
local quat
--[[@type glua_quat]]
quat = ffi.metatype("quat", {
	__index = function (q, i)
		if i == "mat4" then
			local w2 = q.w*q.w
			local x2 = q.x*q.x
			local y2 = q.y*q.y
			local z2 = q.z*q.z
			local m11 = ( x2 - y2 - z2 + w2)
			local m22 = (-x2 + y2 - z2 + w2)
			local m33 = (-x2 - y2 + z2 + w2)
			local xy = q.x*q.y
			local zw = q.z*q.w
			local m21 = 2 * (xy + zw)
			local m12 = 2 * (xy - zw)
			local xz = q.x*q.z
			local yw = q.y*q.w
			local m31 = 2.0 * (xz - yw)
			local m13 = 2.0 * (xz + yw)
			local yz = q.y*q.z
			local xw = q.x*q.w
			local m32 = 2.0 * (yz + xw)
			local m23 = 2.0 * (yz - xw)
			return mat4(
				m11, m21, m31, 0,
				m12, m22, m32, 0,
				m13, m23, m33, 0,
					0,   0,   0, 1
			)
		elseif i == "mat3" then --[[duplicated code would ideally avoid polymorphism]]
			local w2 = q.w*q.w
			local x2 = q.x*q.x
			local y2 = q.y*q.y
			local z2 = q.z*q.z
			local m11 = ( x2 - y2 - z2 + w2)
			local m22 = (-x2 + y2 - z2 + w2)
			local m33 = (-x2 - y2 + z2 + w2)
			local xy = q.x*q.y
			local zw = q.z*q.w
			local m21 = 2 * (xy + zw)
			local m12 = 2 * (xy - zw)
			local xz = q.x*q.z
			local yw = q.y*q.w
			local m31 = 2.0 * (xz - yw)
			local m13 = 2.0 * (xz + yw)
			local yz = q.y*q.z
			local xw = q.x*q.w
			local m32 = 2.0 * (yz + xw)
			local m23 = 2.0 * (yz - xw)
			return mat3(
				m11, m21, m31,
				m12, m22, m32,
				m13, m23, m33
			)
		end
	end,
	__tostring = function (q)
		return string.format("quat [%4.1f %4.1f %4.1f %4.1f]", q.w, q.x, q.y, q.z)
	end,
})


local rotate2 = function (r)
	return mat2(
		cos(r), -sin(r),
		sin(r),  cos(r)
	)
end
local rotate3x = function (r)
	return mat3(
		1,     0,       0,
		0, cos(r), -sin(r),
		0, sin(r),  cos(r)
	)
end
local rotate3y = function (r)
	return mat3(
		 cos(r), 0, sin(r),
		      0, 1,        0,
		-sin(r), 0, cos(r)
	)
end
local rotate3z = function (r)
	return mat3(
		cos(r), -sin(r), 0,
		sin(r),  cos(r), 0,
		     0,         0, 1
	)
end
local rotate3 = function (rx, ry, rz)
	return rotate3x(rx) * rotate3y(ry) * rotate3z(rz)
end
local rotate4x = function (r)
	return mat4(
		1,     0,        0, 0,
		0, cos(r), -sin(r), 0,
		0, sin(r),  cos(r), 0,
		0,      0,       0, 1
	)
end
local rotate4y = function (r)
	return mat4(
		 cos(r), 0, sin(r), 0,
		      0, 1,      0, 0,
		-sin(r), 0, cos(r), 0,
		      0, 0,      0, 1)
end
local rotate4z = function (r)
	return mat4(
		cos(r), -sin(r), 0, 0,
		sin(r),  cos(r), 0, 0,
		     0,       0, 1, 0,
		     0,       0, 0, 1
	)
end
local rotate4 = function (rx, ry, rz) return rotate4x(rx) * rotate4y(ry) * rotate4z(rz) end

mod.mat2 = mat2
mod.mat3 = mat3
mod.mat4 = mat4
mod.mat  = mat4
mod.quat = quat
mod.rotate2  = rotate2
mod.rotate3x = rotate3x
mod.rotate3y = rotate3y
mod.rotate3z = rotate3z
mod.rotate3  = rotate3
mod.rotate4x = rotate4x
mod.rotate4y = rotate4y
mod.rotate4z = rotate4z
mod.rotate4  = rotate4
mod.rotatex  = rotate4x
mod.rotatey  = rotate4y
mod.rotatez  = rotate4z
mod.rotate   = rotate4
mod.identity2 = mat2(
	1, 0,
	0, 1
)
mod.identity3 = mat3(
	1, 0, 0,
	0, 1, 0,
	0, 0, 1
)
mod.identity4 = mat4(
	1, 0, 0, 0,
	0, 1, 0, 0,
	0, 0, 1, 0,
	0, 0, 0, 1
)
mod.identity = mod.identity4

--[[@param x number|glua_vec2|glua_vec3]] --[[@param y? number]] --[[@param z? number]]
mod.translate = function (x, y, z)
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	if ffi.istype(vec2, x) then
		y = x.y
		x = x.x
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	elseif ffi.istype(vec3, x) then
		z = x.z
		y = x.y
		x = x.x
	end
	x = x or 0
	y = y or 0
	z = z or 0
	return mat4(
		1, 0, 0, x,
		0, 1, 0, y,
		0, 0, 1, z,
		0, 0, 0, 1
	)
end

--[[@param x number|glua_vec2|glua_vec3]] --[[@param y? number]] --[[@param z? number]]
mod.scale = function (x, y, z)
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	if ffi.istype(vec2, x) then
		y = x.y
		x = x.x
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	elseif ffi.istype(vec3, x) then
		z = x.z
		y = x.y
		x = x.x
	end
	x = x or 0
	y = y or 0
	z = z or 0
	return mat4(
		x, 0, 0, 0,
		0, y, 0, 0,
		0, 0, z, 0,
		0, 0, 0, 1
	)
end

--[[@param l number]] --[[@param r number]] --[[@param b number]] --[[@param t number]] --[[@param n number]] --[[@param f number]]
mod.frustum = function (l, r, b, t, n, f)
	return mat4(2*n/(r-l),         0,  (r+l)/(r-l),            0,
											0, 2*n/(t-b),  (t+b)/(t-b),            0,
											0,         0, -(f+n)/(f-n), -2*n*f/(f-n),
											0,         0,           -1,            0)
end

--[[@param fovy number]] --[[@param aspect number]] --[[@param n number]] --[[@param f number]]
mod.perspective = function (fovy, aspect, n, f)
	 local t = n * math.tan(fovy * math.pi / 360.0)
	 local r = t * aspect
	 return mod.frustum(-r, r, -t, t, n, f)
end

--[[@param l number]] --[[@param r number]] --[[@param b number]] --[[@param t number]] --[[@param n number]] --[[@param f number]]
mod.ortho = function (l, r, b, t, n, f)
	return mat4(2/(r-l),       0,        0, -(r+l)/(r-l),
										0, 2/(t-b),        0, -(t+b)/(t-b),
										0,       0, -2/(f-n), -(f+n)/(f-n),
										0,       0,        0,            1)
end

return mod
