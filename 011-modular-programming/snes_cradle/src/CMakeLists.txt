cmake_minimum_required( VERSION 3.21 FATAL_ERROR )

target_sources( ${PROJECT_NAME}
    PRIVATE main.s )

add_subdirectory( common )
add_subdirectory( PPU )
add_subdirectory( game )
