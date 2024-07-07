cmake_minimum_required( VERSION 3.21 FATAL_ERROR )

target_compile_options(
    PRIVATE "SHELL:-I ${CMAKE_CURRENT_SOURCE_DIR}"
)

target_sources(
    ${PROJECT_NAME}
    PRIVATE Vector.s
    PRIVATE Joypad.s
    PRIVATE InitSNES.s
)