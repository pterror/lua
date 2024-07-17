return function()
	return lovr.graphics.newShader([[
		vec4 lovrmain() {
			return DefaultPosition;
		}
	]], [[
		#define BANDS 5.0

		vec4 lovrmain() {
			const vec3 lightDirection = vec3(-1, -1, -1);
			vec3 L = normalize(-lightDirection);
			vec3 N = normalize(Normal);
			float normal = .5 + dot(N, L) * .5;

			vec3 baseColor = Color.rgb * normal;
			vec3 clampedColor = round(baseColor * BANDS) / BANDS;

			return vec4(clampedColor, Color.a);
		}
	]])
end
