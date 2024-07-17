local ffi = require("ffi")

local mod = {}

local sky

mod.sky = function()
	if sky then return sky end
	local parts = {} --[[@type string[] ]]
	local blob = lovr.data.newBlob(table.concat(parts), "sky.hdr")
	sky = lovr.graphics.newTexture(blob)
	return sky
end

local write_gltf = function(model, write)
	write(require("deps.lunajson").encode(model))
end

local write_glb = function(model, buffers, write)
	local json_parts = {} --[[@type string[] ]]
	write_gltf(model, function(part) json_parts[#json_parts + 1] = part end)
	local json = table.concat(json_parts)
	--[[@diagnostic disable-next-line: cast-local-type]]
	json_parts = nil
	local buffers_len = 0
	for _, buffer in ipairs(buffers) do buffers_len = buffers_len + ffi.sizeof(buffer) end
	local length = 12 + (8 + #json) + (8 + buffers_len)
	length = length + 8
	local write_u32 = function(n)
		write(string.char(
			bit.band(n, 255),
			bit.band(bit.rshift(n, 8), 255),
			bit.band(bit.rshift(n, 16), 255),
			bit.rshift(n, 24)
		))
	end
	write("glTF\x02\0\0\0")
	write_u32(length)
	write_u32(#json)
	write("JSON")
	write(json)
	write_u32(buffers_len)
	write("BIN\0")
	for _, buffer in ipairs(buffers) do write(ffi.string(ffi.cast("char *", buffer), ffi.sizeof(buffer))) end
end

ffi.cdef [[
	typedef struct { float x; float y; float z; } gltf_point_3d;
	typedef uint16_t gltf_triangle_3d[3];
]]
--[[@class gltf_point_3d: { x: number; y: number; z: number; }]]
--[[@class gltf_triangle_3d: { [0]: integer; [1]: integer; [2]: integer; }]]
--[[@type fun(length: number, points?: gltf_triangle_3d[]): gltf_triangle_3d[] ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local gltf_point_arr = ffi.typeof("gltf_point_3d[?]")
--[[@type fun(length: number, tris?: gltf_triangle_3d[]): gltf_triangle_3d[] ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local tri_arr = ffi.typeof("gltf_triangle_3d[?]")

local gltf = {
	type = { scalar = "SCALAR", vec3 = "VEC3" },
	component_type = { unsigned_short = 5123, float = 5126 },
	target = {
		array_buffer = 34962, --[[attributes]]
		element_array_buffer = 34963, --[[indices]]
	},
	mode = {
		points = 0,
		lines = 1,
		line_loop = 2,
		line_strip = 3,
		triangles = 4 --[[default]],
		triangle_strip = 5,
		triangle_fan = 6,
	}
}

--[[@param tris gltf_triangle_3d[] ]]
mod.model_from_tris = function(tris, points, write)
	local tri_buffer = tri_arr(#tris, tris)
	local point_buffer = gltf_point_arr(#points, points)
	local max_coords = { -1 / 0, -1 / 0, -1 / 0 }
	local min_coords = { 1 / 0, 1 / 0, 1 / 0 }
	for _, point in ipairs(points) do
		max_coords[1] = math.max(point.x, max_coords[1])
		max_coords[2] = math.max(point.y, max_coords[2])
		max_coords[3] = math.max(point.z, max_coords[3])
		min_coords[1] = math.min(point.x, min_coords[1])
		min_coords[2] = math.min(point.y, min_coords[2])
		min_coords[3] = math.min(point.z, min_coords[3])
	end
	local buffers = { tri_buffer, point_buffer }
	local buffer_views = {}
	local buffers_len = 0
	for _, buffer in ipairs(buffers) do
		local len = ffi.sizeof(buffer)
		buffer_views[#buffer_views + 1] = {
			buffer = 0,
			byteLength = len,
			byteOffset = buffers_len,
			target = buffer == tri_buffer
					and gltf.target.element_array_buffer or gltf.target.array_buffer,
		}
		buffers_len = buffers_len + len
	end
	local model = {
		--[[scene/scenes/nodes seem to be optional in lovr but might as well include them]]
		scene = 0,
		scenes = { { nodes = { 0 } } },
		nodes = { { mesh = 0 } },
		buffers = { { byteLength = buffers_len } },
		bufferViews = buffer_views,
		accessors = {
			{
				bufferView = 0,
				byteOffset = 0,
				componentType = gltf.component_type.unsigned_short,
				type = gltf.type.scalar,
				count = #tris * 3,
				max = { #tris - 1 },
				min = { 0 },
			},
			{
				bufferView = 1,
				byteOffset = 0,
				componentType = gltf.component_type.float,
				type = gltf.type.vec3,
				count = #points,
				max = max_coords,
				min = min_coords,
			},
		},
		meshes = {
			{ primitives = { { attributes = { POSITION = 1 }, indices = 0 } } },
		},
	}
	if write then
		write_glb(model, buffers, write)
	else
		local parts = {} --[[@type string[] ]]
		write = function(part) parts[#parts + 1] = part end --[[@param part string]]
		write_glb(model, buffers, write)
		return table.concat(parts)
	end
end

return mod
