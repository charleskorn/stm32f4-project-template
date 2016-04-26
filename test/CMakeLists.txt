set(target_base_name ${application_name}_tests)
project(${target_base_name} CXX)

if(${building_for_target})
    set(executable_file ${target_base_name}.elf)
    set(hex_file ${target_base_name}.hex)
    set(bin_file ${target_base_name}.bin)

    file(GLOB_RECURSE arch_sources target/*.cpp)
endif()

if(${building_for_host})
    set(executable_file ${target_base_name})

    file(GLOB_RECURSE arch_sources host/*.cpp)
endif()

file(GLOB_RECURSE shared_sources tests/*.cpp)
add_executable(${executable_file} ${shared_sources} ${arch_sources})

set(shared_options -Wall -Wextra -Os)
target_compile_options(${executable_file} PRIVATE ${shared_options})
target_link_libraries(${executable_file} PRIVATE ${shared_options})

target_compile_options(${executable_file} PUBLIC -std=c++11)
target_link_libraries(${executable_file} PUBLIC bandit)

if(${building_for_target})
    target_link_libraries(${executable_file} PUBLIC stm32f4xx)
    target_link_libraries(${executable_file} PUBLIC -specs=nano.specs)
    target_link_libraries(${executable_file} PUBLIC -specs=rdimon.specs)
    target_link_libraries(${executable_file} PUBLIC rdimon)

    add_custom_command(OUTPUT ${hex_file} DEPENDS ${executable_file} COMMAND ${CMAKE_OBJCOPY} -Oihex ${executable_file} ${hex_file})
    add_custom_command(OUTPUT ${bin_file} DEPENDS ${executable_file} COMMAND ${CMAKE_OBJCOPY} -Obinary ${executable_file} ${bin_file})
    add_custom_target(${bin_file}-size DEPENDS ${bin_file} COMMAND ${ARM_SIZE_EXECUTABLE} -B -d --target=binary ${bin_file})

    add_custom_target(${target_base_name} ALL DEPENDS ${hex_file} ${bin_file} ${bin_file}-size)

    get_filename_component(run_on_target_script ../tools/run-on-target.sh ABSOLUTE)
    add_custom_target(run_tests DEPENDS ${executable_file} COMMAND
            ${run_on_target_script}
            ${executable_file}
            ${ARM_GDB_EXECUTABLE}
            ${OPENOCD_EXECUTABLE}
            ${OPENOCD_CONFIG})
endif()

if(${building_for_host})
    add_custom_target(run_tests COMMAND ${executable_file})
endif()
