set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

find_program(ARM_SIZE_EXECUTABLE arm-none-eabi-size)
find_program(ARM_GDB_EXECUTABLE arm-none-eabi-gdb)
find_program(OPENOCD_EXECUTABLE openocd)
get_filename_component(OPENOCD_CONFIG ${CMAKE_CURRENT_LIST_DIR}/stm32f4discovery-stlink-v2-1.cfg ABSOLUTE)

set(shared_options "-mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffreestanding -ffunction-sections -fdata-sections")
set(CMAKE_C_FLAGS_INIT "${shared_options}" CACHE INTERNAL "Initial options for C compiler.")
set(CMAKE_CXX_FLAGS_INIT "${shared_options}" CACHE INTERNAL "Initial options for C++ compiler.")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections" CACHE INTERNAL "Initial options for executable linker.")
