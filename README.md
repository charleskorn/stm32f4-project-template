# STM32F4 Discovery board toolchain
A project template for the [STM32F4 Discovery board](http://www.st.com/web/catalog/tools/FM116/SC959/SS1532/PF252419).

Should also be able to be adapted for use with any STM32F4 series MCU.

## Requirements

* [stlink](https://github.com/texane/stlink) - `brew install stlink`
* [CMake](http://cmake.org) - `brew install cmake`
* [GCC ARM toolchain](https://launchpad.net/gcc-arm-embdded) - `brew install gcc-arm-none-eabi-49`

## Setup

	mkdir build
	cd build
	cmake -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm-none-eabi.cmake ..

## Building

	# In the build/ directory created in 'Setup' above
	make

## Flashing firmware

	# In the build/ directory created in 'Setup' above
	make flash_firmware

## Acknowledgements

* [ST's STM32F4 DSP and standard peripherals library](http://www2.st.com/content/st_com/en/products/embedded-software/mcus-embedded-software/stm32-embedded-software/stm32-standard-peripheral-libraries/stsw-stm32065.html)
  Note that the files relating to the FMC have been removed as they are not relevant to the STM32F407.

* [https://github.com/adrienbailly/STM32-CMake-CodeSourcery/blob/master/CMakeLists.txt](https://github.com/adrienbailly/STM32-CMake-CodeSourcery/blob/master/CMakeLists.txt) for CMake snippets

* [http://stackoverflow.com/a/20805828/1668119](http://stackoverflow.com/a/20805828/1668119) for compiler flags

## Contributing

Any suggestions and pull requests welcome.