-- premake5.lua
workspace "MAG"
    architecture "x64"
    configurations
    { 
        "Debug",
        "Release"
    }
    startproject "MAG"

    flags
	{
		"MultiProcessorCompile"
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"
VULKAN_SDK = os.getenv("VULKAN_SDK")

group "Dependencies"
	include "vendor/glfw"
	include "vendor/imgui"
group ""

project "Engine"
    kind "StaticLib"
    language "C++"
    cppdialect "C++20"
    staticruntime "off"

    targetdir ("bin/" .. outputdir)
    objdir ("bin/" .. outputdir .. "/temp")

    files
    {
        "Engine/**.h",
        "Engine/**.cpp",
        "Engine/Core/**.h",
        "Engine/Core/**.cpp",
        "Engine/Graphics/**.h",
        "Engine/Graphics/**.cpp",
        "Engine/Vulkan/**.h",
        "Engine/Vulkan/**.cpp",
        "vendor/stb_image/**.h",
        "vendor/stb_image/**.cpp",
        "vendor/miniaudio/**.h",
        "vendor/glm/glm/**.hpp",
        "vendor/glm/glm/**.inl",
    }

    includedirs
    {
        "Engine",
        "vendor/stb_image",
        "vendor/glfw/include",
        "vendor/glm",
        "vendor/imgui",
        "%{VULKAN_SDK}/Include",
        "vendor/miniaudio",
        "vendor/assimp/include",
		"vendor/freetype/include"
    }
    
    links {
        "GLFW",
        "ImGui"
    }

    defines {
        GLFW_INCLUDE_NONE
    }

    filter { "system:windows" }
        links {
            "assimp.lib",
            "freetype.lib",
            "vulkan-1.lib"
        }
        libdirs {
            "vendor/glew/libs",
            "vendor/freetype/libs",
            "vendor/assimp/libs",
            "%{VULKAN_SDK}/Lib",
        }
        systemversion "latest"

    filter { "system:macosx" }
        defines { "GL_SILENCE_DEPRECATION" }
        linkoptions { "-framework OpenGL -framework Cocoa -framework IOKit" }

    filter "configurations:Debug"
        defines "GLCORE_DEBUG"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "GLCORE_RELEASE"
        runtime "Release"
        optimize "on"

project "MAG"
    kind "ConsoleApp"
        language "C++"
        cppdialect "C++20"
        staticruntime "off"

        targetdir ("bin/" .. outputdir)
        objdir ("bin/" .. outputdir .. "/temp")

        files
        {
            "Game/**.h",
            "Game/**.cpp",
            "Engine/**.h",
            "Engine/Core/**.h",
            "Engine/Graphics/**.h",
            "Engine/Vulkan/**.h",
            "vendor/stb_image/**.h",
            "vendor/miniaudio/**.h",
            "vendor/glm/glm/**.hpp",
            "vendor/glm/glm/**.inl"
        }

        includedirs
        {
            "Game",
            "Engine",
            "vendor/stb_image",
            "vendor/glfw/include",
            "vendor/glm",
            "vendor/imgui",
            "%{VULKAN_SDK}/Include",
            "vendor/miniaudio",
			"vendor/freetype/include"
        }

        links {
            "Engine",
            "GLFW",
            "ImGui"
        }

        filter { "system:windows" }
            links {
                "assimp.lib",
                "freetype.lib",
                "vulkan-1.lib"
            }
            libdirs {
                "vendor/glew/libs",
                "vendor/freetype/libs",
                "vendor/assimp/libs",
                "%{VULKAN_SDK}/Lib",
            }
            systemversion "latest"

        filter { "system:macosx" }
            defines { "GL_SILENCE_DEPRECATION" }
            linkoptions { "-framework OpenGL -framework Cocoa -framework IOKit" }
            linkoptions {"`pkg-config freetype2 --libs --static`"}
            linkoptions {"`pkg-config assimp --libs --static`"}

    
        filter "configurations:Debug"
            defines "GLCORE_DEBUG"
            runtime "Debug"
            symbols "on"

        filter "configurations:Release"
            defines "GLCORE_RELEASE"
            runtime "Release"
            optimize "on"
