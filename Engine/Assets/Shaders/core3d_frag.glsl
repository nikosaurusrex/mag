#version 330 core

in vec3 frag_pos;
in vec2 uv_coord;
in vec3 normal;

out vec4 color;

struct DirectionalLight {
	vec4 ambient;
	vec4 diffuse;
	vec4 specular;
	vec3 dir;
};

struct Material {
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
};

uniform vec3 view_pos;
uniform DirectionalLight dir_light;
uniform Material material;

void main() {
	vec3 norm = normalize(normal);
	vec3 ray = normalize(light.dir);
	
    vec4 ambient = light.ambient * material.ambient;
    float diff = max(dot(norm, ray), 0.0);
    vec4 diffuse = light.diffuse * (diff * material.diffuse);

    vec3 view_dir = normalize(view_pos - frag_pos);
    vec3 reflect_dir = reflect(-ray, norm);  
    float spec = pow(max(dot(view_dir, reflect_dir), 0.0), material.shininess);
    vec4 specular = light.specular * (spec * material.specular);  

    vec4 result = vec4((ambient + diffuse).xyz, 1.0);
    color = result;
}
