project(stm32f4xx C ASM)

set(DEVICE_FAMILY STM32F40_41xxx)
get_filename_component(LINKER_SCRIPT src/stm32f407vg.ld ABSOLUTE)

file(GLOB sources src/*.c src/**/*.c src/*.S)
add_library(stm32f4xx ${sources})

target_include_directories(stm32f4xx PUBLIC inc)
target_include_directories(stm32f4xx PUBLIC inc/cmsis)
target_include_directories(stm32f4xx PUBLIC inc/drivers)

target_compile_definitions(stm32f4xx PUBLIC USE_STDPERIPH_DRIVER)
target_compile_definitions(stm32f4xx PUBLIC ${DEVICE_FAMILY})
target_compile_definitions(stm32f4xx PUBLIC HSE_VALUE=8000000)

set(shared_options -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork -mfloat-abi=hard -ffreestanding -nostdlib -flto -Wall -Wextra -Os)

target_compile_options(stm32f4xx PUBLIC ${shared_options})
target_compile_options(stm32f4xx PUBLIC -ffunction-sections)
target_compile_options(stm32f4xx PUBLIC -fdata-sections)

target_link_libraries(stm32f4xx PUBLIC ${shared_options})
target_link_libraries(stm32f4xx PUBLIC -Wl,--gc-sections)
target_link_libraries(stm32f4xx PUBLIC -T${LINKER_SCRIPT})
