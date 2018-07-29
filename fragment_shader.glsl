#version 430 core

uniform int num_subdivisions;
uniform int num_edges;
uniform int shade_mode;

out vec4 color;

in vec2 uv;
in vec3 normal;
flat in int instance_id;
flat in int vertex_id;

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d ) {
    return a + b*cos( 6.28318*(c*t+d) );
}

void main() {
	float t;
	if (shade_mode == 0) {
		t = (gl_PrimitiveID + 2*instance_id*num_subdivisions)/float(2*num_subdivisions*num_edges - 1);
	} else {
		t = gl_PrimitiveID/float(2*num_subdivisions - 1);
	}
	color = vec4(palette(t, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(1.0, 1.0, 1.0), vec3(0.00, 0.33, 0.67)), 1.0);

	float d = clamp(dot(normal, -vec3(0.0, 0.0, 1.0)), 0.0, 1.0);
	color.xyz = color.xyz*0.8 + 0.2*d;
}
