return function()
	return lovr.graphics.newShader([[
		out vec3 normalDirection;

		vec4 lovrmain() {
			normalDirection = VertexNormal;
			return DefaultPosition;
		}
	]], [[
		in vec3 normalDirection;

		vec4 lovrmain() {
			return vec4(normalDirection * .5 + .5, 1.);
		}
	]])
end
