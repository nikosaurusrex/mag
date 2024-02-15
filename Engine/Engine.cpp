#include <stdio.h>

#include "Core/Window.h"
#include "Core/Input.h"

f64 RenderStats::fps_last_time = 0.0;
u64 RenderStats::fps_temp = 0;

u64 RenderStats::fps = 0;
u64 RenderStats::draw_calls = 0;
u64 RenderStats::triangles = 0;

Engine::Engine() {
    window = new Window("Engine", 1280, 720);
    window->SetEngine(this);
}

Engine::~Engine() {
    delete window;
}

void Engine::Start() {
    running = true;
}

void Engine::Update() {
    RenderStats::draw_calls = 0;
    RenderStats::triangles = 0;

	f64 current_time = glfwGetTime();
	if (current_time - RenderStats::fps_last_time >= 1.0) {
		RenderStats::fps = RenderStats::fps_temp;
		RenderStats::fps_temp = 0;
		RenderStats::fps_last_time = current_time;
        LogDev("FPS: %d", RenderStats::fps);
	}
	RenderStats::fps_temp++;

    window->Update();
        
    if (window->ShouldClose()) {
        running = false;
    }
}

void Engine::HandleEvent(Event event) {
    events.push(event);
}
