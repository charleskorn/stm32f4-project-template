cmake_minimum_required(VERSION 3.2)

set(application_name stm32f4test)

if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "ARM")
    set(building_for_target true)
    set(building_for_host false)
else()
    set(building_for_target false)
    set(building_for_host true)
endif()

add_subdirectory(lib)
add_subdirectory(main)
add_subdirectory(test)
