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

## Tips / gotchas

### IRQ handler isn't being executed

* Make sure your handler matches the name given in `stm32f407vg.S`.

* If your handler is in a C++ file, make sure it is compiled with C linkage (see [this Wikipedia page](https://en.wikipedia.org/wiki/Compatibility_of_C_and_C%2B%2B#Linking_C_and_C.2B.2B_code) for an explanation of why this is necessary).

  This means you should wrap your IRQ handler in `extern "C"`, like this:

  ```cpp
  extern "C" {
    void MyReallyCool_IRQHandler() {

    }
  }
  ```

## Acknowledgements and references

* [ST's STM32F4 DSP and standard peripherals library](http://www2.st.com/content/st_com/en/products/embedded-software/mcus-embedded-software/stm32-embedded-software/stm32-standard-peripheral-libraries/stsw-stm32065.html)

  Note that the files relating to the FMC have been removed as they are not relevant to the STM32F407.

* [ST's clock configuration tool](http://www2.st.com/content/st_com/en/products/development-tools/software-development-tools/stm32-software-development-tools/stm32-configurators-and-code-generators/stsw-stm32091.html)
  for generating `system_stm32f4xx.c`

* [https://github.com/adrienbailly/STM32-CMake-CodeSourcery/blob/master/CMakeLists.txt](https://github.com/adrienbailly/STM32-CMake-CodeSourcery/blob/master/CMakeLists.txt) for CMake snippets

* [http://tech.munts.com/MCU/Frameworks/ARM/stm32f4/](http://tech.munts.com/MCU/Frameworks/ARM/stm32f4/) for linker script and startup assembler

* [http://stackoverflow.com/a/20805828/1668119](http://stackoverflow.com/a/20805828/1668119) for compiler flags

* [http://simplemachines.it/doc/arm_inst.pdf](http://simplemachines.it/doc/arm_inst.pdf) for ARM instruction set (useful when tweaking startup assembly)

## Contributing

Any suggestions and pull requests welcome.