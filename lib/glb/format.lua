local lunajson = require("dep.lunajson")

local mod = {}

mod.null = {}

--[[https://raw.githubusercontent.com/KhronosGroup/glTF/main/specification/2.0/figures/gltfOverview-2.0.0d.png]]

--[[TODO: sparse accessors]]

--[[FIXME: these should be @enums]]
--[[@class gltf_mode_type: integer]]
--[[@class gltf_target_type: integer]]
--[[@class gltf_component_type: integer]]
--[[@class gltf_filter_type: integer]]
--[[@class gltf_wrap_type: integer]]

--[[@class gltf_scene_id: integer]]
--[[@class gltf_node_id: integer]]
--[[@class gltf_camera_id: integer]]
--[[@class gltf_mesh_id: integer]]
--[[@class gltf_buffer_id: integer]]
--[[@class gltf_buffer_view_id: integer]]
--[[@class gltf_accessor_id: integer]]
--[[@class gltf_material_id: integer]]
--[[@class gltf_texture_id: integer]]
--[[@class gltf_image_id: integer]]
--[[@class gltf_sampler_id: integer]]
--[[@class gltf_skin_id: integer]]
--[[@class gltf_animation_id: integer]]

--[[@alias gltf_type_name "VEC2"|"VEC3"|"SCALAR"]]

--[[@class gltf_scene]]
--[[@field nodes gltf_node_id[] ]]

--[[@alias gltf_node gltf_base_node|gltf_matrix_node|gltf_translation_rotation_scale_node]]

--[[@class gltf_base_node]]
--[[@field children? gltf_node_id[] ]]
--[[@field mesh? gltf_mesh_id]]
--[[@field camera? gltf_camera_id]]

--[[@class gltf_matrix_node: gltf_base_node]]
--[[@field matrix {[1]:number,[2]:number,[3]:number,[4]:number,[5]:number,[6]:number,[7]:number,[8]:number,[9]:number,[10]:number,[11]:number,[12]:number,[13]:number,[14]:number,[15]:number,[16]:number} a 4x4 matrix]]

--[[@class gltf_translation_rotation_scale_node: gltf_base_node]]
--[[@field translation? {[1]:number,[2]:number,[3]:number}]]
--[[@field rotation? {[1]:number,[2]:number,[3]:number,[4]:number}]]
--[[@field scale? {[1]:number,[2]:number,[3]:number}]]

--[[@alias gltf_camera gltf_perspective_camera|gltf_orthographic_camera]]

--[[@class gltf_base_camera]]
--[[@field type string]]

--[[@class gltf_perspective_camera: gltf_base_camera]]
--[[@field type "perspective"]]
--[[@field aspectRatio number]]
--[[@field yfov number]]
--[[@field zfar? number]]
--[[@field znear number]]

--[[@class gltf_orthographic_camera: gltf_base_camera]]
--[[@field type "orthographic"]]
--[[@field xmag number]]
--[[@field ymag number]]
--[[@field zfar number]]
--[[@field znear number]]

--[[@class gltf_primitive]]
--[[@field mode gltf_mode_type]]
--[[@field indices? integer]]
--[[@field attributes table<string,gltf_accessor_id>]]
--[[@field material gltf_material_id]]

--[[@class gltf_mesh]]
--[[@field primitives gltf_primitive[] ]]

--[[@class gltf_buffer]]
--[[@field byteLength integer]]

--[[@class gltf_buffer_view]]
--[[@field buffer gltf_buffer_id]]
--[[@field byteOffset? integer]]
--[[@field byteLength integer]]
--[[@field byteStride integer]]
--[[@field count? integer]]
--[[@field target gltf_target_type]]

--[[@alias gltf_accessor gltf_dense_accessor|gltf_sparse_accessor]]

--[[@class gltf_base_accessor]]
--[[@field type gltf_type_name]]
--[[@field componentType gltf_component_type]]
--[[@field count integer]]

--[[@class gltf_dense_accessor: gltf_base_accessor]]
--[[@field bufferView gltf_buffer_view_id]]
--[[@field byteOffset integer]]
--[[@field min {[1]:number,[2]:number}]]
--[[@field max {[1]:number,[2]:number}]]

--[[@class gltf_sparse_accessor_values]]
--[[@field bufferView gltf_buffer_view_id]]

--[[@class gltf_sparse_accessor_indices]]
--[[@field bufferView gltf_buffer_view_id]]
--[[@field componentType gltf_component_type]]

--[[@class gltf_sparse_accessor_data]]
--[[@field count integer]]
--[[@field values gltf_sparse_accessor_values]]
--[[@field indices gltf_sparse_accessor_indices]]

--[[@class gltf_sparse_accessor: gltf_base_accessor]]
--[[@field type gltf_type_name]]
--[[@field componentType gltf_component_type]]
--[[@field count integer]]
--[[@field sparse gltf_sparse_accessor_data]]

--[[@class gltf_base_texture]]
--[[@field index gltf_texture_id]]
--[[@field texCoord integer]]

--[[@class gltf_base_color_texture: gltf_base_texture]]
--[[@class gltf_base_color_factor: {[1]:number,[2]:number,[3]:number,[4]:number} red, green, blue, alpha, all 0 to 1]]
--[[@class gltf_metallic_roughness_texture: gltf_base_texture]]

--[[@class gltf_pbr_metallic_roughness]]
--[[@field baseColorTexture gltf_base_color_texture]]
--[[@field baseColorFactor gltf_base_color_factor]]
--[[@field metallicRoughnessTexture gltf_metallic_roughness_texture]]
--[[@field metallicFactor number 0 to 1]]
--[[@field roughnessFactor number 0 to 1]]

--[[@class gltf_normal_texture: gltf_base_texture]]
--[[@field scale number]]

--[[@class gltf_occlusion_texture: gltf_base_texture]]
--[[@field strength number]]

--[[@class gltf_emissive_texture: gltf_base_texture]]
--[[@class gltf_emissive_factor: {[1]:number,[2]:number,[3]:number} red, green, blue, all 0 to 1]]

--[[@class gltf_material]]
--[[@field pbrMetallicRoughness gltf_pbr_metallic_roughness]]
--[[@field normalTexture gltf_normal_texture]]
--[[@field occlusionTexture gltf_occlusion_texture]]
--[[@field emissiveTexture gltf_emissive_texture]]
--[[@field emissiveFactor gltf_emissive_factor]]

--[[@class gltf_texture]]
--[[@field source gltf_image_id]]
--[[@field sampler integer index]]

--[[@alias gltf_image gltf_uri_image|gltf_buffer_view_image]]

--[[@class gltf_uri_image]]
--[[@field uri string]]

--[[@class gltf_buffer_view_image]]
--[[@field bufferView gltf_buffer_view_id]]
--[[@field mimeType string]]

--[[@class gltf_sampler]]
--[[@field magFilter gltf_filter_type]]
--[[@field minFilter gltf_filter_type]]
--[[@field wrapS gltf_wrap_type]]
--[[@field wrapT gltf_wrap_type]]
--[[@field wrapR gltf_wrap_type]]

--[[@class gltf_model]]
--[[@field scene? gltf_scene_id]]
--[[@field scenes gltf_scene[] ]]
--[[@field nodes gltf_node[] ]]
--[[@field cameras gltf_camera[] ]]
--[[@field meshes gltf_mesh[] ]]
--[[@field buffers gltf_buffer[] ]]
--[[@field bufferViews gltf_buffer_view[] ]]
--[[@field accessors gltf_accessor[] ]]
--[[@field materials gltf_material[] ]]
--[[@field textures gltf_texture[] ]]
--[[@field images gltf_image[] ]]
--[[@field samplers gltf_sampler[] ]]
--[[@field skins unknown[] ]]
--[[@field animations unknown[] ]]

--[[@alias glb_chunk glb_binary_chunk|glb_json_chunk|glb_other_chunk]]

--[[@param s string]] --[[@param i integer]]
local read_u32 = function (s, i)
	local a, b, c, d = s:byte(i, i + 3)
	return bit.bor(a, bit.lshift(b, 8), bit.lshift(c, 16), bit.lshift(d, 24))
end

--[[@param s string]] --[[@param i integer]]
mod.string_to_model = function (s, i)
	i = i or 1
	--[[@diagnostic disable-next-line: cast-local-type]]
	local header, i2 = mod.read_header(s, i)
	if not header or type(i2) == "string" then
		return nil, (type(i2) == "string" and i2 or ("glb.format.string_to_model: unknown error: " .. tostring(i2)))
	end
	local end_ = i + header.length - 1
	local chunks = {} --[[@type glb_chunk[] ]]
	local gltf --[[@type gltf_model]]
	i = i2
	while i <= end_ do
		local chunk
		chunk, i = mod.read_chunk(s, i)
		--[[@diagnostic disable-next-line: assign-type-mismatch]]
		if chunk.type == "JSON" then gltf = chunk.data --[[@type gltf_model]]
		else chunks[#chunks+1] = chunk end
	end
	local model = { --[[@class glb_model]]
		version = header.version, gltf = gltf, chunks = chunks
	}
	return model, end_ + 1
end

--[[@return glb_header? header, string|integer error_or_i]]
--[[@param s string]] --[[@param i integer]]
mod.read_header = function (s, i)
	if s:sub(i, i + 3) ~= "glTF" then return nil, "glb.format.read_header: missing \"glTF\" header" end
	if #s < 8 then return nil, "glb.format.read_header: missing version number" end
	if #s < 8 then return nil, "glb.format.read_header: missing length" end
	local version = read_u32(s, i + 4)
	local length = read_u32(s, i + 8)
	local header = { --[[@class glb_header]]
		version = version, length = length
	}
	return header, i + 12
end

--[[FIXME: change chunk type parsers to use lookup table]]

--[[@param s string]] --[[@param i integer]]
mod.read_chunk = function (s, i)
	local length = read_u32(s, i)
	local type = s:sub(i + 4, i + 7)
	local obj
	if type == "JSON" then
		--[[@diagnostic disable-next-line: cast-local-type]]
		local value, i2 = lunajson.json_to_value(s, i + 8, lunajson.null)
		if i2 ~= i + 8 + length - 1 then
			io.stderr:write(
				"glb.format.read_chunk: json chunk ended at " .. tostring(i + 8 + length - 1) ..
				", actually ended at " .. tostring(i2) .. "\n"
			)
		end
		obj = { type = "JSON", data = value } --[[@class glb_json_chunk]]
	else
		local data = s:sub(i + 8, i + 8 + length - 1)
		if type == "BIN\0" then
			obj = { type = "BIN\0", data = data } --[[@class glb_binary_chunk]]
		else
			obj = { type = type, data = data } --[[@class glb_other_chunk]]
		end
	end
	return obj, i + 8 + length
end

return mod
