if(${building_for_target})
    set(target_base_name ${application_name}_firmware)
    project(${target_base_name} CXX)

    set(elf_file ${target_base_name}.elf)
    set(hex_file ${target_base_name}.hex)
    set(bin_file ${target_base_name}.bin)

    file(GLOB sources *.cpp)
    add_executable(${elf_file} ${sources})
    target_link_libraries(${elf_file} PUBLIC stm32f4xx)

    set(shared_options -Wall -Wextra -Os -nostdlib)
    target_compile_options(${elf_file} PRIVATE ${shared_options})
    target_link_libraries(${elf_file} PRIVATE ${shared_options})

    target_compile_options(${elf_file} PUBLIC -fno-exceptions)
    target_compile_options(${elf_file} PUBLIC -fno-rtti)
    target_compile_options(${elf_file} PUBLIC -std=c++11)

    add_custom_command(OUTPUT ${hex_file} DEPENDS ${elf_file} COMMAND ${CMAKE_OBJCOPY} -Oihex ${elf_file} ${hex_file})
    add_custom_command(OUTPUT ${bin_file} DEPENDS ${elf_file} COMMAND ${CMAKE_OBJCOPY} -Obinary ${elf_file} ${bin_file})
    add_custom_target(${bin_file}-size DEPENDS ${bin_file} COMMAND ${ARM_SIZE_EXECUTABLE} -B -d --target=binary ${bin_file})

    add_custom_target(${target_base_name} ALL DEPENDS ${hex_file} ${bin_file} ${bin_file}-size)

    find_program(ST_FLASH_EXECUTABLE st-flash)
    add_custom_target(flash_firmware DEPENDS ${bin_file}-size COMMAND ${ST_FLASH_EXECUTABLE} --reset write ${bin_file} 0x8000000)
endif()
