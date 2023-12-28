#!/usr/bin/env luajit
local arg = arg --[[@type unknown[] ]]
if pcall(debug.getlocal, 4, 1) then arg = { ... }
else package.path = arg[0]:gsub("lua/.+$", "lua/?.lua", 1) .. ";" .. package.path end

local xlib = require("dep.xlib")

--[[@param x? integer]] --[[@param y? integer]] --[[@param width? integer]] --[[@param height? integer]]
local new_window = function (x, y, width, height)
	local display = assert(xlib.display:new())
	local screen = display.c[0].screens[display.c[0].default_screen]
	x = x or 0
	y = y or 0
	width = width or screen.width
	height = height or screen.height
	return {
		window = display:create_simple_window(
			screen.root, x, y, width, height, 0, 0, 0
		),
		width = width, height = height
	}
end

local model_path = arg[1]
if string.find(model_path, "%.glb$") then
	local model, err = require("lib.glb.format").string_to_model(io.open(model_path):read("*all"))
	if not model then
		io.stderr:write(tostring(err) .. "\n")
		os.exit(1)
	end
	--[[https://gltf-viewer-tutorial.gitlab.io/initialization/]]
	local gl = require("dep.glua.init")

	local buffers = model.gltf.buffers
	local buffer_objects = gl.GenBuffers(#buffers)
	for i = 1, #buffers do
		gl.BindBuffer(gl.ARRAY_BUFFER, buffer_objects[i - 1])
		--[[byteLength may be too long. note that data is aligned to 4 bytes.]]
		gl.BufferStorage(gl.ARRAY_BUFFER, buffers[i].byteLength, model.chunks[i].data, 0)
	end
	gl.BindBuffer(gl.ARRAY_BUFFER, 0)

	local meshes = model.gltf.meshes
	local accessors = model.gltf.accessors
	local buffer_views = model.gltf.bufferViews

	local vertex_array_count = 0
	for _, mesh in pairs(meshes) do vertex_array_count = vertex_array_count + #mesh.primitives end
	local vertex_array_objects = gl.GenVertexArrays(vertex_array_count)
	local j = 0
	local num_components = { VEC3 = 3, VEC2 = 2 }
	local VERTEX_ATTRIB_POSITION_IDX = 0
	local VERTEX_ATTRIB_NORMAL_IDX = 1
	local VERTEX_ATTRIB_TEXCOORD0_IDX = 2
	for _, mesh in pairs(meshes) do
		for _, primitive in pairs(mesh.primitives) do
			local vao = vertex_array_objects[j]
			j = j + 1
			gl.BindVertexArray(vao)
			local byte_offset_ptr = require("ffi").new("int[1]")
			local pos = primitive.attributes["POSITION"]
			if pos then
				local accessor = accessors[pos + 1]
				local buffer_view = buffer_views[accessor.bufferView + 1]
				local buffer_i = buffer_view.buffer
				gl.EnableVertexAttribArray(VERTEX_ATTRIB_POSITION_IDX)
				assert(buffer_view.target == gl.ARRAY_BUFFER)
				gl.BindBuffer(gl.ARRAY_BUFFER, buffer_objects[buffer_i])
				byte_offset_ptr[0] = (accessor.byteOffset or 0) + buffer_view.byteOffset
				gl.VertexAttribPointer(VERTEX_ATTRIB_POSITION_IDX, num_components[accessor.type], accessor.componentType, gl.FALSE, buffer_view.byteStride, byte_offset_ptr)
			end
			pos = primitive.attributes["NORMAL"]
			if pos then
				local accessor = accessors[pos + 1]
				local buffer_view = buffer_views[accessor.bufferView + 1]
				local buffer_i = buffer_view.buffer
				gl.EnableVertexAttribArray(VERTEX_ATTRIB_NORMAL_IDX)
				assert(buffer_view.target == gl.ARRAY_BUFFER)
				gl.BindBuffer(gl.ARRAY_BUFFER, buffer_objects[buffer_i])
				byte_offset_ptr[0] = (accessor.byteOffset or 0) + buffer_view.byteOffset
				gl.VertexAttribPointer(VERTEX_ATTRIB_NORMAL_IDX, num_components[accessor.type], accessor.componentType, gl.FALSE, buffer_view.byteStride, byte_offset_ptr)
			end
			pos = primitive.attributes["TEXCOORD_0"]
			if pos then
				local accessor = accessors[pos + 1]
				local buffer_view = buffer_views[accessor.bufferView + 1]
				local buffer_i = buffer_view.buffer
				gl.EnableVertexAttribArray(VERTEX_ATTRIB_TEXCOORD0_IDX)
				assert(buffer_view.target == gl.ARRAY_BUFFER)
				gl.BindBuffer(gl.ARRAY_BUFFER, buffer_objects[buffer_i])
				byte_offset_ptr[0] = (accessor.byteOffset or 0) + buffer_view.byteOffset
				gl.VertexAttribPointer(VERTEX_ATTRIB_TEXCOORD0_IDX, num_components[accessor.type], accessor.componentType, gl.FALSE, buffer_view.byteStride, byte_offset_ptr)
			end
			if primitive.indices then
				local accessor = model.gltf.accessors[primitive.indices]
				local buffer_view = buffer_views[accessor.bufferView + 1]
				local buffer_i = buffer_view.buffer
				assert(buffer_view.target == gl.ELEMENT_ARRAY_BUFFER or buffer_view.target == gl.ARRAY_BUFFER)
				gl.BindBuffer(buffer_view.target, buffer_objects[buffer_i])
			end
		end
	end
	gl.BindVertexArray(0)

	local window = new_window()
	gl.Viewport(0, 0, window.width, window.height)
	gl.Clear(bit.bor(gl.COLOR_BUFFER_BIT, gl.DEPTH_BUFFER_BIT))
	local view_matrix = camera.getViewMatrix()
	--[[TODO: draw scene]]
	local glsl_program = gl.compileProgram({"./3d_view/vs.glsl", "./3d_view/fs.glsl"})

	local model_view_proj_matrix_location = gl.GetUniformLocation(glsl_program.glId(), "uModelViewProjMatrix")
	local model_view_matrix_location = gl.GetUniformLocation(glsl_program.glId(), "uModelViewMatrix")
	local normal_matrix_location = gl.GetUniformLocation(glsl_program.glId(), "uNormalMatrix")


	local nodes = model.gltf.nodes
	local draw_node
	--[[@param i integer node index]] --[[@param parent_matrix glm_mat4]]
	draw_node = function (i, parent_matrix)
		local node = nodes[i]
		local model_matrix = gl.getLocalToWorldMatrix(node, parent_matrix)
		if node.mesh then
			local mv_matrix = view_matrix * model_matrix
			local mvp_matrix = proj_matrix * mv_matrix
			local normal_matrix = mv_matrix.inv.t

			gl.UniformMatrix4fv(model_view_proj_matrix_location, 1, gl.FALSE, mvp_matrix.gl)
			gl.UniformMatrix4fv(model_view_matrix_location, 1, gl.FALSE, mvMatrix.gl)
			gl.UniformMatrix4fv(normal_matrix_location, 1, gl.FALSE, normalMatrix.gl)

		end
	end
	
	if model.gltf.scene then
		--[[TODO Draw all nodes]]
	end
end
