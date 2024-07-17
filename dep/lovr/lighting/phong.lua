return function()
	return lovr.graphics.newShader([[
		out vec3 lightDirection;
		out vec3 normalDirection;

		// TODO: this should be an input
		vec3 lightPosition = vec3(0, 10, -10);

		vec4 lovrmain() {
			vec4 vVertex = Transform * VertexPosition;
			vec4 vLight = Transform * vec4(lightPosition, 1.);

			lightDirection = normalize(vec3(vLight - vVertex));
			normalDirection = normalize(NormalMatrix * VertexNormal);

			return DefaultPosition;
		}
	]], [[
		in vec3 lightDirection;
		in vec3 normalDirection;

		vec3 cAmbient = vec3(.2);
		vec3 cDiffuse = vec3(.8);
		vec3 cSpecular = vec3(.2);

		vec4 lovrmain() {
			float diffuse = max(dot(normalDirection, lightDirection), 0.);
			float specular = 0.;

			if (diffuse > 0.) {
				vec3 r = reflect(lightDirection, normalDirection);
				vec3 viewDirection = normalize(-vec3(gl_FragCoord));

				float specularAngle = max(dot(r, viewDirection), 0.);
				specular = pow(specularAngle, 5.);
			}

			vec3 cFinal = vec3(diffuse) * cDiffuse + vec3(specular) * cSpecular;
			cFinal = clamp(cFinal, cAmbient, vec3(1.));
			return vec4(cFinal, 1.) * Color * getPixel(ColorTexture, UV);
		}
	]])
end
