local ffi = require("ffi")
local gl = require("dep.glua.init")

local float_max = 340282346638528859811704183484516925440
local float_lowest = -340282346638528859811704183484516925440

--[[@return glua_mat4]]
--[[@param node gltf_node]] --[[@param parent_matrix glua_mat4]]
local get_local_to_world_matrix = function (node, parent_matrix)
	--[[Extract model matrix]]
	--[[https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md#transformations]]
	if node.matrix then
		return parent_matrix * gl.mat4(
			node.matrix[0], node.matrix[1], node.matrix[2], node.matrix[3],
			node.matrix[4], node.matrix[5], node.matrix[6], node.matrix[7],
			node.matrix[8], node.matrix[9], node.matrix[10], node.matrix[11],
			node.matrix[12], node.matrix[13], node.matrix[14], node.matrix[15]
		)
	end
	local T = node.translation and parent_matrix * gl.translate(unpack(node.translation, 1, 3)) or parent_matrix
	local rotation_quat = node.rotation
		and gl.quat(node.rotation[4], node.rotation[1], node.rotation[2], node.rotation[3]) --[[rototype is w, x, y, z]]
		or gl.quat(1, 0, 0, 0)
	local TR = T * rotation_quat.mat4
	return node.scale and TR * gl.scale(unpack(node.scale, 1, 3)) or TR
end

--[[@param model gltf_model]] --[[@param buffers { data: string }[] ]]
local compute_scene_bounds = function (model, buffers)
	--[[Compute scene bounding box]]
	--[[todo refactor with scene drawing]]
	--[[todo need a visitScene generic function that takes a accept() functor]]
	local bbox_min = gl.vec3(float_max, float_max, float_max)
	local bbox_max = gl.vec3(float_lowest, float_lowest, float_lowest)
	if model.scene then
		local update_bounds
		--[[@param nodeIdx integer]] --[[@param parentMatrix glua_mat4]]
		update_bounds = function (nodeIdx, parentMatrix)
			local node = model.nodes[nodeIdx]
			local model_matrix = get_local_to_world_matrix(node, parentMatrix)
			if node.mesh >= 0 then
				local mesh = model.meshes[node.mesh]
				for _, primitive in ipairs(mesh.primitives) do
					local pos = primitive.attributes["POSITION"]
					if pos then
						local positionAccessor = model.accessors[pos + 1]
						if positionAccessor.type ~= 3 then
							io.stderr:write("Position accessor with type != VEC3, skipping")
						else
							local positionBufferView = model.bufferViews[positionAccessor.bufferView + 1]
							local byteOffset = positionAccessor.byteOffset + positionBufferView.byteOffset
							local positionBuffer = model.buffers[positionBufferView.buffer + 1]
							local positionByteStride = positionBufferView.byteStride and positionBufferView.byteStride or 3 * ffi.sizeof("float")
							if primitive.indices >= 0 then
								local indexAccessor = model.accessors[primitive.indices + 1]
								local indexBufferView = model.bufferViews[indexAccessor.bufferView + 1]
								local indexByteOffset = indexAccessor.byteOffset + indexBufferView.byteOffset
								local indexBuffer = buffers[indexBufferView.buffer + 1].data
								local indexByteStride = indexBufferView.byteStride

								-- switch (indexAccessor.componentType) {
								-- default:
								-- 	std.cerr
								-- 			<< "Primitive index accessor with bad componentType "
								-- 			<< indexAccessor.componentType << ", skipping it."
								-- 			<< std.endl
								-- 	continue
								-- case TINYGLTF_COMPONENT_TYPE_UNSIGNED_BYTE:
								-- 	indexByteStride =
								-- 			indexByteStride ? indexByteStride : sizeof(uint8_t)
								-- 	break
								-- case TINYGLTF_COMPONENT_TYPE_UNSIGNED_SHORT:
								-- 	indexByteStride =
								-- 			indexByteStride ? indexByteStride : sizeof(uint16_t)
								-- 	break
								-- case TINYGLTF_COMPONENT_TYPE_UNSIGNED_INT:
								-- 	indexByteStride =
								-- 			indexByteStride ? indexByteStride : sizeof(uint32_t)
								-- 	break
								-- end

								for i = 1, #indexAccessor do
									local index = 0
									-- switch (indexAccessor.componentType) {
									-- case TINYGLTF_COMPONENT_TYPE_UNSIGNED_BYTE:
									-- 	index = *((const uint8_t *)&indexBuffer
									-- 								.data[indexByteOffset + indexByteStride * i])
									-- 	break
									-- case TINYGLTF_COMPONENT_TYPE_UNSIGNED_SHORT:
									-- 	index = *((const uint16_t *)&indexBuffer
									-- 								.data[indexByteOffset + indexByteStride * i])
									-- 	break
									-- case TINYGLTF_COMPONENT_TYPE_UNSIGNED_INT:
									-- 	index = *((const uint32_t *)&indexBuffer
									-- 								.data[indexByteOffset + indexByteStride * i])
									-- 	break
									-- end
									local localPosition = positionBuffer[byteOffset + positionByteStride * index]
									local worldPosition = gl.vec3(model_matrix * gl.vec4(localPosition, 1))
									bbox_min = bbox_min:min(worldPosition)
									bbox_max = bbox_max:max(worldPosition)
								end
							else
								for i = 1, #positionAccessor do
									local localPosition = positionBuffer[byteOffset + positionByteStride * i]
									local worldPosition = gl.vec3(model_matrix * gl.vec4(localPosition, 1))
									bbox_min = bbox_min:min(worldPosition)
									bbox_max = bbox_max:max(worldPosition)
								end
							end
						end
					end
				end
			end
			for _, childNodeIdx in ipairs(node.children) do
				update_bounds(childNodeIdx, model_matrix)
			end
		end
		for _, i in ipairs(model.scenes[model.scene].nodes) do
			update_bounds(i, gl.mat4(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
		end
	end
	return bbox_min,  bbox_max
end

--[[
	default sampler:
	https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md#texturesampler
	"When undefined, a sampler with repeat wrapping and local filtering should
	be used."
]]
--[[@type gltf_sampler]]
local default_sampler = {
	minFilter = gl.LINEAR,
	magFilter = gl.LINEAR,
	wrapS = gl.REPEAT,
	wrapT = gl.REPEAT,
	wrapR = gl.REPEAT,
}

--[[@param model gltf_model]]
local create_texture_objects = function (model)
	gl.ActiveTexture(gl.TEXTURE0)
	local texture_objects = gl.GenTextures(gl.sizei(#model.textures))
	for i = 1, #model.textures do
		local texture = model.textures[i]
		assert(texture.source >= 0)
		local image = model.images[texture.source]
		local sampler = texture.sampler and model.samplers[texture.sampler] or default_sampler
		gl.BindTexture(gl.TEXTURE_2D, texture_objects[i])
		gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGBA, image.width, image.height, 0, gl.RGBA, image.pixel_type, image.image.data())
		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, sampler.minFilter ~= -1 and sampler.minFilter or gl.LINEAR)
		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, sampler.magFilter ~= -1 and sampler.magFilter or gl.LINEAR)
		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, sampler.wrapS)
		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, sampler.wrapT)
		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_R, sampler.wrapR or gl.REPEAT)
		if sampler.minFilter == gl.NEAREST_MIPMAP_NEAREST or
				sampler.minFilter == gl.NEAREST_MIPMAP_LINEAR or
				sampler.minFilter == gl.LINEAR_MIPMAP_NEAREST or
				sampler.minFilter == gl.LINEAR_MIPMAP_LINEAR then
			gl.GenerateMipmap(gl.TEXTURE_2D)
		end
	end
	gl.BindTexture(gl.TEXTURE_2D, 0)

	return texture_objects
end

--[[@param model gltf_model]] --[[@param buffers { data: string }[] ]]
local create_buffer_objects = function (model, buffers)
	local buffer_objects = gl.GenBuffers(#model.buffers)
	for i = 1, #model.buffers do
		gl.BindBuffer(gl.ARRAY_BUFFER, buffer_objects[i - 1])
		--[[byteLength may be too long. note that data is aligned to 4 bytes.]]
		gl.BufferStorage(gl.ARRAY_BUFFER, model.buffers[i].byteLength, buffers[i].data, 0)
	end
	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
end

local num_components = { VEC3 = 3, VEC2 = 2 }

local attrs = {
	{ attribute = "POSITION", index = 0 },
	{ attribute = "NORMAL", index = 1 },
	{ attribute = "TEXCOORD_0", index = 2 },
}

--[[@param model gltf_model]] --[[@param buffer_objects gl_uintv_c[] ]]
local create_vertex_array_objects = function (model, buffer_objects)
	--[[For each mesh of model we keep its range of VAOs]]
	local mesh_to_vertex_arrays = {} --[[@type {begin:integer, end_: integer}[] ]]

	local meshes = model.meshes
	local accessors = model.accessors
	local buffer_views = model.bufferViews

	local vertex_array_count = 0
	for _, mesh in pairs(meshes) do vertex_array_count = vertex_array_count + #mesh.primitives end
	local vertex_array_objects = gl.GenVertexArrays(vertex_array_count)

	local byte_offset_ptr = require("ffi").new("int[1]")
	local j = 0
	for i, mesh in ipairs(meshes) do
		mesh_to_vertex_arrays[i] = { begin = j, end_ = j + #mesh.primitives - 1 }
		for pIdx = 1, #mesh.primitives do
			local vao = vertex_array_objects[j]
			j = j + 1
			local primitive = mesh.primitives[pIdx]
			gl.BindVertexArray(vao)
			for _, it in ipairs(attrs) do
				local pos = primitive.attributes[it.attribute]
				if pos then
					local accessor = accessors[pos + 1]
					local buffer_view = buffer_views[accessor.bufferView + 1]
					local buffer_i = buffer_view.buffer
					gl.EnableVertexAttribArray(it.index)
					assert(buffer_view.target == gl.ARRAY_BUFFER)
					--[[Theorically we could also use bufferView.target, but it is safer]]
					--[[Here it is important to know that the next call]]
					--[[(gl.VertexAttribPointer) use what is currently bound]]
					gl.BindBuffer(gl.ARRAY_BUFFER, buffer_objects[buffer_i])
					byte_offset_ptr[0] = (accessor.byteOffset or 0) + buffer_view.byteOffset
					gl.VertexAttribPointer(it.index, num_components[accessor.type], accessor.componentType, gl.FALSE, buffer_view.byteStride, byte_offset_ptr)
				end
			end
			if primitive.indices then
				local accessor = accessors[primitive.indices]
				local buffer_view = buffer_views[accessor.bufferView + 1]
				local buffer_i = buffer_view.buffer
				assert(buffer_view.target == gl.ELEMENT_ARRAY_BUFFER or buffer_view.target == gl.ARRAY_BUFFER)
				--[[Binding the index buffer to gl.ELEMENT_ARRAY_BUFFER while the VAO]]
				--[[is bound is enough to tell OpenGL we want to use that index buffer for that VAO]]
				gl.BindBuffer(buffer_view.target, buffer_objects[buffer_i])
			end
		end
	end
	gl.BindVertexArray(0)
	return vertex_array_objects, mesh_to_vertex_arrays
end

--[[@param glb_model glb_model]] --[[@param width integer]] --[[@param height integer]]
local run = function (glb_model, width, height)
	local prog = gl.CreateProgram()
	local vs = gl.CreateShader(gl.VERTEX_SHADER)
	gl.CompileShader(vs)
	--[[TODO: attach shader]]
	gl.AttachShader(prog, vs)
	local fs = gl.CreateShader(gl.FRAGMENT_SHADER)
	gl.CompileShader(fs)
	gl.AttachShader(prog, fs)

	local model_view_proj_matrix_location = gl.GetUniformLocation(prog.gl.Id(), "uModelViewProjMatrix")
	local model_view_matrix_location = gl.GetUniformLocation(prog.gl.Id(), "uModelViewMatrix")
	local normal_matrix_location = gl.GetUniformLocation(prog.gl.Id(), "uNormalMatrix")
	local u_light_direction_location = gl.GetUniformLocation(prog.gl.Id(), "uLightDirection")
	local u_light_intensity = gl.GetUniformLocation(prog.gl.Id(), "uLightIntensity")
	local u_base_color_texture = gl.GetUniformLocation(prog.gl.Id(), "uBaseColorTexture")
	local u_base_color_factor = gl.GetUniformLocation(prog.gl.Id(), "uBaseColorFactor")
	local u_metallic_roughness_texture = gl.GetUniformLocation(prog.gl.Id(), "uMetallicRoughnessTexture")
	local u_metallic_factor = gl.GetUniformLocation(prog.gl.Id(), "uMetallicFactor")
	local u_roughness_factor = gl.GetUniformLocation(prog.gl.Id(), "uRoughnessFactor")
	local u_emissive_texture = gl.GetUniformLocation(prog.gl.Id(), "uEmissiveTexture")
	local u_emissive_factor = gl.GetUniformLocation(prog.gl.Id(), "uEmissiveFactor")
	local u_occlusion_texture = gl.GetUniformLocation(prog.gl.Id(), "uOcclusionTexture")
	local u_occlusion_strength = gl.GetUniformLocation(prog.gl.Id(), "uOcclusionStrength")
	local u_apply_occlusion = gl.GetUniformLocation(prog.gl.Id(), "uApplyOcclusion")

	local model = glb_model.gltf
	local bbox_min, bbox_max = compute_scene_bounds(model, glb_model.chunks)
	--[[Build projection matrix]]
	local diag = bbox_max - bbox_min
	local max_distance = diag.length
	local proj_matrix = gl.perspective(70, width / height, 0.001 * max_distance, 1.5 * max_distance)

	--[[Init light parameters]]
	local light_direction = gl.vec3(1, 1, 1)
	local light_intensity = gl.vec3(1, 1, 1)
	local light_from_camera = false
	local apply_occlusion = true
	--[[Load textures]]
	local texture_objects = create_texture_objects(model)
	local white_texture = ffi.new("int [1]") --[[@type {[0]:integer}]]

	--[[Create white texture for object with no base color texture]]
	gl.GenTextures(1, white_texture)
	gl.BindTexture(gl.TEXTURE_2D, white_texture)
	local white = {1, 1, 1, 1}
	gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.FLOAT, white)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_R, gl.REPEAT)
	gl.BindTexture(gl.TEXTURE_2D, 0)

	local buffer_objects = create_buffer_objects(model, glb_model.chunks)
	local vertex_array_objects, mesh_to_vertex_arrays = create_vertex_array_objects(model, buffer_objects)

	--[[Setup OpenGL state for rendering]]
	gl.Enable(gl.DEPTH_TEST)
	gl.UseProgram(prog)

	local bind_material = function (material_index)
		if material_index >= 0 then
			local material = model.materials[material_index + 1]
			local pbr_metallic_roughness = material.pbrMetallicRoughness
			if u_base_color_factor >= 0 then
				gl.Uniform4f(
					u_base_color_factor,
					pbr_metallic_roughness.baseColorFactor[0],
					pbr_metallic_roughness.baseColorFactor[1],
					pbr_metallic_roughness.baseColorFactor[2],
					pbr_metallic_roughness.baseColorFactor[3]
				)
			end
			if u_base_color_texture >= 0 then
				local texture_object = white_texture[0]
				if pbr_metallic_roughness.baseColorTexture.index >= 0 then
					local texture =
							model.textures[pbr_metallic_roughness.baseColorTexture.index + 1]
					if texture.source >= 0 then
						texture_object = texture_objects[texture.source]
					end
				end

				gl.ActiveTexture(gl.TEXTURE0)
				gl.BindTexture(gl.TEXTURE_2D, texture_object)
				gl.Uniform1i(u_base_color_texture, 0)
			end
			if u_metallic_factor >= 0 then
				gl.Uniform1f(u_metallic_factor, pbr_metallic_roughness.metallicFactor)
			end
			if u_roughness_factor >= 0 then
				gl.Uniform1f(u_roughness_factor, pbr_metallic_roughness.roughnessFactor)
			end
			if u_metallic_roughness_texture >= 0 then
				local textureObject = 0
				if pbr_metallic_roughness.metallicRoughnessTexture.index >= 0 then
					local texture =
							model.textures[pbr_metallic_roughness.metallicRoughnessTexture.index + 1]
					if texture.source >= 0 then
						textureObject = texture_objects[texture.source]
					end
				end

				gl.ActiveTexture(gl.TEXTURE1)
				gl.BindTexture(gl.TEXTURE_2D, textureObject)
				gl.Uniform1i(u_metallic_roughness_texture, 1)
			end
			if u_emissive_factor >= 0 then
				gl.Uniform3f(
					u_emissive_factor,
					material.emissiveFactor[0], material.emissiveFactor[1], material.emissiveFactor[2]
				)
			end
			if u_emissive_texture >= 0 then
				local textureObject = 0
				if material.emissiveTexture.index >= 0 then
					local texture = model.textures[material.emissiveTexture.index]
					if texture.source >= 0 then textureObject = texture_objects[texture.source] end
				end

				gl.ActiveTexture(gl.TEXTURE2)
				gl.BindTexture(gl.TEXTURE_2D, textureObject)
				gl.Uniform1i(u_emissive_texture, 2)
			end
			if u_occlusion_strength >= 0 then
				gl.Uniform1f(u_occlusion_strength, material.occlusionTexture.strength)
			end
			if u_occlusion_texture >= 0 then
				local textureObject = white_texture
				if material.occlusionTexture.index >= 0 then
					local texture = model.textures[material.occlusionTexture.index]
					if texture.source >= 0 then
						textureObject = texture_objects[texture.source]
					end
				end

				gl.ActiveTexture(gl.TEXTURE3)
				gl.BindTexture(gl.TEXTURE_2D, textureObject)
				gl.Uniform1i(u_occlusion_texture, 3)
			end
		else
			--[[Apply default material]]
			--[[Defined here:]]
			--[[https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md#reference-material]]
			--[[https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md#reference-pbrmetallicroughness3]]
			if u_base_color_factor >= 0 then gl.Uniform4f(u_base_color_factor, 1, 1, 1, 1) end
			if u_base_color_texture >= 0 then
				gl.ActiveTexture(gl.TEXTURE0)
				gl.BindTexture(gl.TEXTURE_2D, white_texture)
				gl.Uniform1i(u_base_color_texture, 0)
			end
			if u_metallic_factor >= 0 then gl.Uniform1f(u_metallic_factor, 1) end
			if u_roughness_factor >= 0 then gl.Uniform1f(u_roughness_factor, 1) end
			if u_metallic_roughness_texture >= 0 then
				gl.ActiveTexture(gl.TEXTURE1)
				gl.BindTexture(gl.TEXTURE_2D, 0)
				gl.Uniform1i(u_metallic_roughness_texture, 1)
			end
			if u_emissive_factor >= 0 then gl.Uniform3f(u_emissive_factor, 0, 0, 0) end
			if u_emissive_texture >= 0 then
				gl.ActiveTexture(gl.TEXTURE2)
				gl.BindTexture(gl.TEXTURE_2D, 0)
				gl.Uniform1i(u_emissive_texture, 2)
			end
			if u_occlusion_strength >= 0 then gl.Uniform1f(u_occlusion_strength, 0) end
			if u_occlusion_texture >= 0 then
				gl.ActiveTexture(gl.TEXTURE3)
				gl.BindTexture(gl.TEXTURE_2D, 0)
				gl.Uniform1i(u_occlusion_texture, 3)
			end
		end
	end

	--[[Lambda function to draw the scene]]
	--[[@param view_matrix glua_mat4]] --[[@param width integer]] --[[@param height integer]]
	local draw_scene = function (view_matrix, width, height)
		gl.Viewport(0, 0, width, height)
		gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)

		if u_light_direction_location >= 0 then
			if light_from_camera then gl.Uniform3f(u_light_direction_location, 0, 0, 1)
			else
				local lightDirectionInViewSpace = gl.vec3(view_matrix * gl.vec4(light_direction, 0.)).normalize
				gl.Uniform3f(
					u_light_direction_location,
					lightDirectionInViewSpace[0], lightDirectionInViewSpace[1], lightDirectionInViewSpace[2]
				)
			end
		end

		if u_light_intensity >= 0 then
			gl.Uniform3f(u_light_intensity, light_intensity[0], light_intensity[1], light_intensity[2])
		end
		if u_apply_occlusion >= 0 then gl.Uniform1i(u_apply_occlusion, apply_occlusion) end

		--[[The recursive function that should draw a node]]
		local draw_node
		--[[@param i integer]] --[[@param parent_matrix glua_mat4]]
		draw_node = function (i, parent_matrix)
					local node = model.nodes[i]
					local model_matrix = get_local_to_world_matrix(node, parent_matrix)

					--[[If the node references a mesh (a node can also reference a]]
					--[[camera, or a light)]]
					if node.mesh >= 0 then
						local mv_matrix = view_matrix * model_matrix --[[Also called localToCamera matrix]]
						local mvp_matrix = proj_matrix * mv_matrix --[[Also called localToScreen matrix]]
						--[[Normal matrix is necessary to maintain normal vectors]]
						--[[orthogonal to tangent vectors]]
						--[[https://www.lighthouse3d.com/tutorials/glsl-12-tutorial/the-normal-matrix/]]
						local normal_matrix = mv_matrix.inv.t

						gl.UniformMatrix4fv(model_view_proj_matrix_location, 1, gl.FALSE, mvp_matrix.gl)
						gl.UniformMatrix4fv(
								model_view_matrix_location, 1, gl.FALSE, mv_matrix.gl)
						gl.UniformMatrix4fv(normal_matrix_location, 1, gl.FALSE, normal_matrix.gl)

						local mesh = model.meshes[node.mesh]
						--[[FIXME: fill mesh_to_vertex_arrays. but maybe store only start index instead]]
						local vao_range = mesh_to_vertex_arrays[node.mesh]
						for pIdx = 1, #mesh.primitives do
							local vao = vertex_array_objects[vao_range.begin + pIdx]
							local primitive = mesh.primitives[pIdx]

							bind_material(primitive.material)

							gl.BindVertexArray(vao)
							if primitive.indices >= 0 then
								local accessor = model.accessors[primitive.indices + 1]
								local bufferView = model.bufferViews[accessor.bufferView + 1]
								local byteOffset =
										accessor.byteOffset + bufferView.byteOffset
								gl.DrawElements(primitive.mode, gl.sizei(accessor.count),
										accessor.componentType, byteOffset)
							else
								--[[Take first accessor to get the count]]
								local accessorIdx = primitive.attributes[1].second
								local accessor = model.accessors[accessorIdx]
								gl.DrawArrays(primitive.mode, 0, gl.sizei(accessor.count))
							end
						end
					end

					--[[Draw children]]
					for _, i in pairs(node.children) do
						draw_node(i, model_matrix)
					end
				end

		--[[Draw the scene referenced by gltf file]]
		if model.scene then
			for _, i in ipairs(model.scenes[model.scene].nodes) do
				draw_node(i, gl.mat4(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1))
			end
		end
	end

	--[[FIXME: sleep]]
	draw_scene(camera_controller:get_camera())

	--[[TODO: clean up rest of allocated GL data]]
	gl.DetachShader(prog, vs)
	gl.DeleteShader(vs)
	gl.DetachShader(prog, fs)
	gl.DeleteShader(fs)
	gl.DeleteProgram(prog)
end
