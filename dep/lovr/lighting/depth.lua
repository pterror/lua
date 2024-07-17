return function()
	return lovr.graphics.newShader([[
		out float depth;

		vec4 lovrmain() {
			vec4 result = DefaultPosition;
			depth = result.z / result.w;
			return result;
		}
	]], [[
		in float depth;

		vec4 lovrmain() {
			return vec4(vec3(depth), 1.);
		}
	]])
end
