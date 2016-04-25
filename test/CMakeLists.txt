set(target_base_name ${application_name}_tests)
project(${target_base_name} CXX)

set(elf_file ${target_base_name}.elf)
set(hex_file ${target_base_name}.hex)
set(bin_file ${target_base_name}.bin)

file(GLOB_RECURSE sources *.cpp)
add_executable(${elf_file} ${sources})
target_link_libraries(${elf_file} PUBLIC stm32f4xx)
target_link_libraries(${elf_file} PUBLIC bandit)

set(shared_options -Wall -Wextra -Os)
target_compile_options(${elf_file} PRIVATE ${shared_options})
target_link_libraries(${elf_file} PRIVATE ${shared_options})

target_compile_options(${elf_file} PUBLIC -std=c++11)
target_link_libraries(${elf_file} PUBLIC -specs=nano.specs)
target_link_libraries(${elf_file} PUBLIC -specs=rdimon.specs)
target_link_libraries(${elf_file} PUBLIC rdimon)

add_custom_command(OUTPUT ${hex_file} DEPENDS ${elf_file} COMMAND ${CMAKE_OBJCOPY} -Oihex ${elf_file} ${hex_file})
add_custom_command(OUTPUT ${bin_file} DEPENDS ${elf_file} COMMAND ${CMAKE_OBJCOPY} -Obinary ${elf_file} ${bin_file})
add_custom_target(${bin_file}-size DEPENDS ${bin_file} COMMAND ${ARM_SIZE_EXECUTABLE} -B -d --target=binary ${bin_file})

add_custom_target(${target_base_name} ALL DEPENDS ${hex_file} ${bin_file} ${bin_file}-size)

get_filename_component(openocd_config ../tools/stm32f4discovery-stlink-v2-1.cfg ABSOLUTE)
get_filename_component(run_on_target_script ../tools/run-on-target.sh ABSOLUTE)
find_program(OPENOCD_EXECUTABLE openocd)
add_custom_target(run_tests DEPENDS ${elf_file} COMMAND
        ${run_on_target_script}
        ${elf_file}
        ${ARM_GDB_EXECUTABLE}
        ${OPENOCD_EXECUTABLE}
        ${openocd_config})
