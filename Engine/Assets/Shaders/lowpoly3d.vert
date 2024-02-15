#version 450

layout (location = 0) in vec3 in_position;
layout (location = 1) in vec2 in_texture_coords;
layout (location = 2) in vec3 in_normal;

layout (location=0) out vec4 frag_color;

layout (binding=0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

layout (binding=1) uniform Material {
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} mat;

layout (binding=2) uniform DirectionalLight {
	vec4 ambient;
	vec4 diffuse;
	vec3 dir;
} dir_light;

struct PointLight {
	vec4 ambient;
	vec4 diffuse;
	vec3 pos;
};

layout (binding=3) uniform PointLights {
	uint count;
    PointLight lights[10];
} point_lights;

vec3 CalculateDirLight(vec3 normal) {
	vec3 ray = normalize(dir_light.dir);
	
    vec4 ambient = dir_light.ambient * mat.ambient;
    float diff = max(dot(normal, ray), 0.0);
    vec4 diffuse = dir_light.diffuse * (diff * mat.diffuse);

	return (ambient + diffuse).xyz;
}

vec3 CalculatePointLight(PointLight light, vec3 normal, vec3 frag_pos) {
	vec3 ray = normalize(light.pos - frag_pos);
	
	vec4 ambient = light.ambient * mat.ambient;
	float diff = max(dot(normal, ray), 0.0);
	vec4 diffuse = light.diffuse * (diff * mat.diffuse);

	return (ambient + diffuse).xyz;
}

void main() {
	vec4 world_pos = ubo.model * vec4(in_position, 1.0);

	gl_Position = ubo.proj * ubo.view * world_pos;
 
	vec3 frag_pos = world_pos.xyz;
    vec3 normal = mat3(transpose(inverse(ubo.model))) * in_normal;
	vec3 norm = normalize(normal);

	vec3 result = CalculateDirLight(norm);

	for (int i = 0; i < point_lights.count; i++) {
		result += CalculatePointLight(point_lights.lights[i], norm, frag_pos);
	}

    frag_color = vec4(mat.diffuse.xyz, 1.0);
}
