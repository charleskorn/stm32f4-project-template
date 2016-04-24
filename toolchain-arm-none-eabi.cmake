include(CMakeForceCompiler)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR ARM)

CMAKE_FORCE_C_COMPILER(arm-none-eabi-gcc GNU)
CMAKE_FORCE_CXX_COMPILER(arm-none-eabi-g++ GNU)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

find_program(ARM_SIZE_EXECUTABLE arm-none-eabi-size)

set(shared_options "-mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffreestanding -ffunction-sections -fdata-sections")
set(CMAKE_C_FLAGS_INIT "${shared_options}" CACHE INTERNAL "Initial options for C compiler.")
set(CMAKE_CXX_FLAGS_INIT "${shared_options}" CACHE INTERNAL "Initial options for C++ compiler.")
set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--gc-sections" CACHE INTERNAL "Initial options for executable linker.")
