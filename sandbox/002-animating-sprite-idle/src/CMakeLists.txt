cmake_minimum_required( VERSION 3.21 FATAL_ERROR )

target_sources(
    PRIVATE main.s
)

add_subdirectory( common )
add_subdirectory( ppu )
add_subdirectory( game )