local ffi = require("ffi")

--[[
Copyright 2016 Thibault Charbonnier

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

ffi.cdef [[
	typedef enum Argon2_type { Argon2_d  = 0, Argon2_i = 1, Argon2_id = 2 } argon2_type;

	const char *argon2_error_message(int error_code);
	size_t argon2_encodedlen(uint32_t t_cost, uint32_t m_cost, uint32_t parallelism, uint32_t saltlen, uint32_t hashlen, argon2_type type);
	int argon2i_hash_encoded(const uint32_t t_cost,
														const uint32_t m_cost,
														const uint32_t parallelism,
														const void *pwd, const size_t pwdlen,
														const void *salt, const size_t saltlen,
														const size_t hashlen, char *encoded,
														const size_t encodedlen);
	int argon2d_hash_encoded(const uint32_t t_cost,
														const uint32_t m_cost,
														const uint32_t parallelism,
														const void *pwd, const size_t pwdlen,
														const void *salt, const size_t saltlen,
														const size_t hashlen, char *encoded,
														const size_t encodedlen);
	int argon2id_hash_encoded(const uint32_t t_cost,
														const uint32_t m_cost,
														const uint32_t parallelism,
														const void *pwd, const size_t pwdlen,
														const void *salt, const size_t saltlen,
														const size_t hashlen, char *encoded,
														const size_t encodedlen);
	int argon2_verify(const char *encoded, const void *pwd, const size_t pwdlen, argon2_type type);
]]

--- @class argon2_error_c
--- @class argon2_type_c

--- @alias argon2_algorithm fun(t_cost: integer,  m_cost: integer, parallelism: integer, pwd: string, pwdlen: integer, salt: string, saltlen: integer, hashlen: integer, encoded: string, encodedlen: integer): argon2_error_c

--- @class ffi_argon2
--- @field argon2_error_message fun(error_code: argon2_error_c): string
--- @field argon2_encodedlen fun(t_cost: integer, m_cost: integer, parallelism: integer, saltlen: integer, hashlen: integer, type: argon2_type_c): integer
--- @field argon2i_hash_encoded argon2_algorithm
--- @field argon2d_hash_encoded argon2_algorithm
--- @field argon2id_hash_encoded argon2_algorithm
--- @field argon2_verify fun(encoded: string, pwd: string, pwdlen: integer, type: argon2_type_c): argon2_error_c

--- @type ffi_argon2
local ffi_argon2 = ffi.load("argon2")

local ARGON2_OK = 0
local ARGON2_VERIFY_MISMATCH = -35

local mod = {}
mod.metadata = { version = "3.0.1", author = "Thibault Charbonnier", license = "MIT", url = "https://github.com/thibaultcha/lua-argon2-ffi" }
mod.variants = {
	argon2_i = ffi.new("argon2_type", "Argon2_i"), --- @type argon2_type_c
	argon2_d = ffi.new("argon2_type", "Argon2_d"), --- @type argon2_type_c
	argon2_id = ffi.new("argon2_type", "Argon2_id"), --- @type argon2_type_c
}
local argon2_i = mod.variants.argon2_i
local argon2_d = mod.variants.argon2_d
local argon2_id = mod.variants.argon2_id

--- @class argon2_opts
--- @field t_cost integer
--- @field m_cost integer
--- @field parallelism integer
--- @field hash_len 32
--- @field variant argon2_type_c

--- @param pwd string
--- @param salt string
--- @param opts argon2_opts?
function mod.hash_encoded(pwd, salt, opts)
	opts = opts or {}
	local t_cost = opts.t_cost or 3
	local m_cost = opts.m_cost or 4096
	local parallelism = opts.parallelism or 1
	local hash_len = opts.hash_len or 32
	local variant = opts.variant or argon2_i

	local buf_len = ffi_argon2.argon2_encodedlen(t_cost, m_cost, parallelism, #salt, hash_len, variant)

	local buf = ffi.new("char[?]", buf_len)
	local ret

	if opts.variant == argon2_d then
		ret = ffi_argon2.argon2d_hash_encoded(t_cost, m_cost, parallelism, pwd, #pwd, salt, #salt, hash_len, buf, buf_len)
	elseif opts.variant == argon2_id then
		ret = ffi_argon2.argon2id_hash_encoded(t_cost, m_cost, parallelism, pwd, #pwd, salt, #salt, hash_len, buf, buf_len)
	else
		ret = ffi_argon2.argon2i_hash_encoded(t_cost, m_cost, parallelism, pwd, #pwd, salt, #salt, hash_len, buf, buf_len)
	end

	if ret ~= ARGON2_OK then return nil, ffi.string(ffi_argon2.argon2_error_message(ret)) end
	return ffi.string(buf)
end

--- @param encoded string
--- @param plain string
function mod.verify(encoded, plain)
	local variant

	if string.find(encoded, "argon2d", nil, true) then
		variant = argon2_d
	elseif string.find(encoded, "argon2id", nil, true) then
		variant = argon2_id
	else
		variant = argon2_i
	end

	local ret = ffi_argon2.argon2_verify(encoded, plain, #plain, variant)
	if ret == ARGON2_VERIFY_MISMATCH then return false end
	if ret ~= ARGON2_OK then return nil, ffi.string(ffi_argon2.argon2_error_message(ret)) end
	return true
end

return mod
