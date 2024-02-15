#include "Common.h"

#include "Core/Camera.h"
#include "Core/Input.h"
#include "Core/Sound.h"
#include "Core/Window.h"
#include "Engine.h"

#include "Vulkan/VulkanRenderer.h"
#include "Graphics/Model.h"
#include "Graphics/SceneRenderer.h"

#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEFAULT_ALIGNED_GENTYPES
#define GLM_FORCE_DEPTH_ZERO_TO_ONE
#include "glm/ext/matrix_clip_space.hpp"
#include "glm/ext/matrix_transform.hpp"
#define GLM_ENABLE_EXPERIMENTAL
#include <glm/gtx/quaternion.hpp>
#include <glm/gtx/transform.hpp>

#include <chrono>

glm::mat4 TranslateScale(glm::vec3 trans, glm::vec3 scale) {
	return  glm::translate(glm::mat4(1.0f), trans) *
		glm::scale(glm::mat4(1.0f), scale);
}

glm::mat4 TranslateRotate(glm::vec3 trans, glm::vec3 rot) {
	return  glm::translate(glm::mat4(1.0f), trans) *
		glm::toMat4(glm::quat(glm::radians(rot)));
}

glm::mat4 TranslateRotateScale(glm::vec3 trans, glm::vec3 rot, glm::vec3 scale) {
	return  glm::translate(glm::mat4(1.0f), trans) *
		glm::toMat4(glm::quat(glm::radians(rot))) *
		glm::scale(glm::mat4(1.0f), scale);
}

struct Door {
	bool open = false;
	f32 open_degree = 0.0f;
	f32 target_degree = 0.0f;
	glm::mat4 wall_mat;
	glm::mat4 door_mat;
	Sound *sound_door_open;
	Sound *sound_door_close;

	Door() {
		wall_mat = glm::toMat4(glm::quat(glm::radians(glm::vec3(0.0f, 0.0f, 0.0f))));
		door_mat = glm::translate(glm::mat4(1.0), glm::vec3(0.0f, 0.0f, 0.50f));

        sound_door_open = new Sound("Game/Assets/Sounds/door_open.wav");
        sound_door_close = new Sound("Game/Assets/Sounds/door_close.wav");
	}

	~Door() {
		delete sound_door_open;
		delete sound_door_close;
	}

	void Render(f32 delta_time) {
		const f32 speed = 66.5f * delta_time;
		if (open) {
			open_degree += speed;
			if (open_degree > 90.0f) {
				open_degree = 90.0f;
			}
		} else {
			open_degree -= speed;
			if (open_degree < 0.0f) {
				open_degree = 0.0f;
			}
		}

		/*
		Shader *shader = shaders[SHADER_LOWPOLY];
		Model *model_wall = models[MODEL_WALL_DOOR];
		Model *model = models[MODEL_DOOR];

		shader->Use();
		model_mat->Set(wall_mat);
		renderer->Render(model_wall);

		model_mat->Set(door_mat);
		renderer->Render(model);*/
	}

	void OpenOrClose() {
		open = !open;
		if (open) {
			sound_door_open->Play();
		} else {
			sound_door_close->Play();
		}
	}
};

int main() {
    Engine engine;

    engine.window->EnableRawInput();
	engine.window->SetVSync(true);

    engine.Start();

	InitSound();

    VulkanContext context = VulkanContext::Get(true);
    VulkanInstance::Create(&context, engine.window->handle, "Engine");

    VulkanPhysicalDevice::Pick(&context);
    VulkanDevice::Create(&context);

    VulkanDevice *device = VulkanDevice::Get();

    VulkanSwapchain swapchain;
    swapchain.Create(true);

    RenderPass render_pass;
    render_pass.Create(&swapchain);

	SceneRenderer *renderer = new SceneRenderer(&swapchain, &render_pass);

	Model *model_well = ModelImporter::Load("Game/Assets/Models/village/Prop_Well_1.obj", render_pass.graphics_command_pool.handle);

	SceneData scene_data;

	FreeCamera camera(glm::vec3(0.0));
	camera.Calculate(engine.window->bounds.width, engine.window->bounds.height);

	DirectionalLight dir_light;
	dir_light.dir = glm::vec3(0.3f, 1.0f, 0.3f);
	dir_light.ambient = glm::vec4(0.2f);
	dir_light.diffuse = glm::vec4(1.0f);
	scene_data.dir_light = dir_light;

	PointLight point_light;
	point_light.pos = glm::vec3(-10.0f, 2.0f, -10.0f);
	point_light.ambient = glm::vec4(0.2f);
	point_light.diffuse = glm::vec4(1.0f);

	scene_data.point_lights[0] = point_light;
	scene_data.num_point_lights = 1;

	bool show_editor = false;
	bool show_render_stats = false;
	bool wireframe = false;

	f64 last_time = glfwGetTime();
	f32 delta_time = 0.0f;

	f64 waterwheel_angle = 0.0f;

	Door door;

    while (engine.running) {
        while (!engine.events.empty()) {
            Event event = engine.events.front();
            engine.events.pop();

            switch (event.type) {
				case Event::Resize: {
					// framebuffer.Resize(event.width, event.height);
					// font_renderer.Resize(event.width, event.height);
					camera.Calculate(event.width, event.height);
				} break;
                case Event::Key: {
					if (event.action == GLFW_RELEASE) {
						if (event.button == (int)KeyCode::E) {
							door.OpenOrClose();
						}
						if (event.button == (int)KeyCode::F11) {
							engine.window->ToggleFullscreen();
						}
						if (event.button == (int)KeyCode::F3) {
							show_render_stats = !show_render_stats;
						}
						if (event.button == (int)KeyCode::F4) {
							show_editor = !show_editor;
							if (show_editor) {
								Input::Lock();
								engine.window->SetHideCursor(false);
							} else {
								Input::Unlock();
								engine.window->SetHideCursor(true);
							}
						}
					}
                } break;
            }
        }

		if (Input::IsKeyDown(KeyCode::Q) && Input::IsKeyDown(KeyCode::LeftControl)) {
			engine.running = false;
		}

		f64 current_time = glfwGetTime();
		delta_time = (f32) (current_time - last_time);
		last_time = current_time;

        camera.Update(engine.window, delta_time);
		Input::Update(engine.window);
        engine.Update();

		scene_data.projection = camera.projection;
		scene_data.view = camera.view;

		renderer->Begin();

		renderer->SetSceneData(&scene_data);
		renderer->RenderModel(model_well);

		renderer->End();
    }

    VK_CHECK(vkDeviceWaitIdle(device->handle));

	delete model_well;
	delete renderer;

    render_pass.Destroy();

    swapchain.Destroy();
    VulkanDevice::Destroy();
    VulkanInstance::Destroy();

	DeinitSound();

	return 0;
}