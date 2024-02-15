#version 330 core

layout (location = 0) in vec4 pos;
layout (location = 1) in vec2 texture_coords;
layout (location = 2) in vec3 in_normal;

out vec3 frag_pos;
out vec2 uv_coord;
out vec3 normal;

uniform mat4 proj_mat;
uniform mat4 view_mat;
uniform mat4 model_mat;

void main() {
	vec4 world_pos = model_mat * pos;

	gl_Position = proj_mat * view_mat * world_pos;

	frag_pos = world_pos.xyz;
	uv_coord = texture_coords;
    normal = mat3(transpose(inverse(model_mat))) * in_normal;
}