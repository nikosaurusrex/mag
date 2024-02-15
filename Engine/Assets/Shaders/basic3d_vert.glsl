#version 330 core

layout (location = 0) in vec4 pos;

uniform mat4 proj_mat;
uniform mat4 view_mat;
uniform mat4 model_mat;

void main() {
    vec4 out_frag_pos = model_mat * pos;

    gl_Position = proj_mat * view_mat * out_frag_pos;
}