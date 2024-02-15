add_library("ImGui" STATIC
  "vendor/imgui/imconfig.h"
  "vendor/imgui/imgui.cpp"
  "vendor/imgui/imgui.h"
  "vendor/imgui/imgui_demo.cpp"
  "vendor/imgui/imgui_draw.cpp"
  "vendor/imgui/imgui_internal.h"
  "vendor/imgui/imgui_tables.cpp"
  "vendor/imgui/imgui_widgets.cpp"
  "vendor/imgui/imstb_rectpack.h"
  "vendor/imgui/imstb_textedit.h"
  "vendor/imgui/imstb_truetype.h"
)
if(CMAKE_BUILD_TYPE STREQUAL Debug)
  set_target_properties("ImGui" PROPERTIES
    OUTPUT_NAME "ImGui"
    ARCHIVE_OUTPUT_DIRECTORY "E:/work/mag/vendor/imgui/bin/Debug-windows-x86_64/ImGui"
    LIBRARY_OUTPUT_DIRECTORY "E:/work/mag/vendor/imgui/bin/Debug-windows-x86_64/ImGui"
    RUNTIME_OUTPUT_DIRECTORY "E:/work/mag/vendor/imgui/bin/Debug-windows-x86_64/ImGui"
  )
endif()
target_include_directories("ImGui" PRIVATE
)
target_compile_definitions("ImGui" PRIVATE
)
target_link_directories("ImGui" PRIVATE
)
target_link_libraries("ImGui"
)
target_compile_options("ImGui" PRIVATE
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:-m64>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C>>:-g>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-m64>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-g>
  $<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:CXX>>:-std=c++17>
)
if(CMAKE_BUILD_TYPE STREQUAL Debug)
  set_target_properties("ImGui" PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
    POSITION_INDEPENDENT_CODE False
    INTERPROCEDURAL_OPTIMIZATION False
  )
endif()
if(CMAKE_BUILD_TYPE STREQUAL Release)
  set_target_properties("ImGui" PROPERTIES
    OUTPUT_NAME "ImGui"
    ARCHIVE_OUTPUT_DIRECTORY "E:/work/mag/vendor/imgui/bin/Release-windows-x86_64/ImGui"
    LIBRARY_OUTPUT_DIRECTORY "E:/work/mag/vendor/imgui/bin/Release-windows-x86_64/ImGui"
    RUNTIME_OUTPUT_DIRECTORY "E:/work/mag/vendor/imgui/bin/Release-windows-x86_64/ImGui"
  )
endif()
target_include_directories("ImGui" PRIVATE
)
target_compile_definitions("ImGui" PRIVATE
)
target_link_directories("ImGui" PRIVATE
)
target_link_libraries("ImGui"
)
target_compile_options("ImGui" PRIVATE
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:C>>:-m64>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:C>>:-O2>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:-m64>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:-O2>
  $<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:CXX>>:-std=c++17>
)
if(CMAKE_BUILD_TYPE STREQUAL Release)
  set_target_properties("ImGui" PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
    POSITION_INDEPENDENT_CODE False
    INTERPROCEDURAL_OPTIMIZATION False
  )
endif()