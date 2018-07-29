#version 430 core

uniform int num_edges;
uniform int num_subdivisions;
uniform int num_twists;

uniform float time;
uniform vec2 res;

uniform float rot_x;
uniform float rot_y;

flat out int instance_id;
flat out int vertex_id;
out vec2 uv;
out vec3 normal;

mat4 rotate(vec3 axis, float angle);

#define PI 3.14159265358979323846 

void main() {
	instance_id = gl_InstanceID;
	vertex_id = gl_VertexID;

	float R = 1.0;
	float r = 0.2;

	float u = ((gl_VertexID % 2) + gl_InstanceID)/float(num_edges);
	float v = (gl_VertexID / 2)/float(num_subdivisions);
	uv = vec2(u, v);

	vec3 p = vec3(
		(R + r*cos(2.0*PI*(u+num_twists*v/num_edges)))*cos(2.0*PI*v), 
		(R + r*cos(2.0*PI*(u+num_twists*v/num_edges)))*sin(2.0*PI*v), 
		r*sin(2.0*PI*(u+num_twists*v/num_edges))
	);

	normal = normalize(p - vec3(R*cos(2.0*PI*v), R*sin(2.0*PI*v), 0.0));
	normal = (rotate(vec3(0.0, 1.0, 0.0), rot_y)*vec4(normal, 1.0)).xyz;
	normal = (rotate(vec3(1.0, 0.0, 0.0), rot_x)*vec4(normal, 1.0)).xyz;

	p = (rotate(vec3(0.0, 1.0, 0.0), rot_y)*vec4(p, 1.0)).xyz;
	p = (rotate(vec3(1.0, 0.0, 0.0), rot_x)*vec4(p, 1.0)).xyz;

	//p = vec3(vec2(u, v)*2-1, 0.0);
	p *= 0.8;
	p.x /= res.x/res.y;

    gl_Position = vec4(p, 1.0);
}

mat4 rotate(vec3 axis, float angle) {
    float s = sin(angle);
    float c = cos(angle);;

    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}
