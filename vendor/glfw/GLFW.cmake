add_library("GLFW" STATIC
      "vendor/glfw/include/GLFW/glfw3.h"
      "vendor/glfw/include/GLFW/glfw3native.h"
    "vendor/glfw/src/context.c"
    "vendor/glfw/src/egl_context.c"
    "vendor/glfw/src/init.c"
    "vendor/glfw/src/input.c"
    "vendor/glfw/src/monitor.c"
    "vendor/glfw/src/null_init.c"
    "vendor/glfw/src/null_joystick.c"
    "vendor/glfw/src/null_monitor.c"
    "vendor/glfw/src/null_window.c"
    "vendor/glfw/src/osmesa_context.c"
    "vendor/glfw/src/platform.c"
    "vendor/glfw/src/vulkan.c"
    "vendor/glfw/src/wgl_context.c"
    "vendor/glfw/src/win32_init.c"
    "vendor/glfw/src/win32_joystick.c"
    "vendor/glfw/src/win32_module.c"
    "vendor/glfw/src/win32_monitor.c"
    "vendor/glfw/src/win32_thread.c"
    "vendor/glfw/src/win32_time.c"
    "vendor/glfw/src/win32_window.c"
    "vendor/glfw/src/window.c"
)
if(CMAKE_BUILD_TYPE STREQUAL Debug)
  set_target_properties("GLFW" PROPERTIES
    OUTPUT_NAME "GLFW"
    ARCHIVE_OUTPUT_DIRECTORY "E:/work/mag/vendor/glfw/bin/Debug-windows-x86_64/GLFW"
    LIBRARY_OUTPUT_DIRECTORY "E:/work/mag/vendor/glfw/bin/Debug-windows-x86_64/GLFW"
    RUNTIME_OUTPUT_DIRECTORY "E:/work/mag/vendor/glfw/bin/Debug-windows-x86_64/GLFW"
  )
endif()
target_include_directories("GLFW" PRIVATE
)
target_compile_definitions("GLFW" PRIVATE
  $<$<CONFIG:Debug>:_GLFW_WIN32>
  $<$<CONFIG:Debug>:_CRT_SECURE_NO_WARNINGS>
)
target_link_directories("GLFW" PRIVATE
)
target_link_libraries("GLFW"
)
target_compile_options("GLFW" PRIVATE
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:-m64>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:-g>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:-w>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-m64>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-g>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-w>
)
if(CMAKE_BUILD_TYPE STREQUAL Release)
  set_target_properties("GLFW" PROPERTIES
    OUTPUT_NAME "GLFW"
    ARCHIVE_OUTPUT_DIRECTORY "E:/work/mag/vendor/glfw/bin/Release-windows-x86_64/GLFW"
    LIBRARY_OUTPUT_DIRECTORY "E:/work/mag/vendor/glfw/bin/Release-windows-x86_64/GLFW"
    RUNTIME_OUTPUT_DIRECTORY "E:/work/mag/vendor/glfw/bin/Release-windows-x86_64/GLFW"
  )
endif()
target_include_directories("GLFW" PRIVATE
)
target_compile_definitions("GLFW" PRIVATE
  $<$<CONFIG:Release>:_GLFW_WIN32>
  $<$<CONFIG:Release>:_CRT_SECURE_NO_WARNINGS>
)
target_link_directories("GLFW" PRIVATE
)
target_link_libraries("GLFW"
)
target_compile_options("GLFW" PRIVATE
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:C>>:-m64>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:C>>:-O3>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:C>>:-w>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:-m64>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:-O3>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:-w>
)