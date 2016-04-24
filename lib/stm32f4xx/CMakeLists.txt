project(stm32f4xx C ASM)

set(DEVICE_FAMILY STM32F40_41xxx)
get_filename_component(LINKER_SCRIPT src/stm32f407vg.ld ABSOLUTE)

set(sources
	src/system_stm32f4xx.c
	src/drivers/misc.c
	src/drivers/stm32f4xx_adc.c
	src/drivers/stm32f4xx_can.c
	src/drivers/stm32f4xx_cec.c
	src/drivers/stm32f4xx_crc.c
	src/drivers/stm32f4xx_cryp.c
	src/drivers/stm32f4xx_cryp_aes.c
	src/drivers/stm32f4xx_cryp_des.c
	src/drivers/stm32f4xx_cryp_tdes.c
	src/drivers/stm32f4xx_dac.c
	src/drivers/stm32f4xx_dbgmcu.c
	src/drivers/stm32f4xx_dcmi.c
	src/drivers/stm32f4xx_dma.c
	src/drivers/stm32f4xx_dma2d.c
	src/drivers/stm32f4xx_dsi.c
	src/drivers/stm32f4xx_exti.c
	src/drivers/stm32f4xx_flash.c
	src/drivers/stm32f4xx_flash_ramfunc.c
	# src/drivers/stm32f4xx_fmc.c # Disabled because this file does not compile when targeting the STM32F407VG.
	src/drivers/stm32f4xx_fmpi2c.c
	src/drivers/stm32f4xx_fsmc.c
	src/drivers/stm32f4xx_gpio.c
	src/drivers/stm32f4xx_hash.c
	src/drivers/stm32f4xx_hash_md5.c
	src/drivers/stm32f4xx_hash_sha1.c
	src/drivers/stm32f4xx_i2c.c
	src/drivers/stm32f4xx_iwdg.c
	src/drivers/stm32f4xx_lptim.c
	src/drivers/stm32f4xx_ltdc.c
	src/drivers/stm32f4xx_pwr.c
	src/drivers/stm32f4xx_qspi.c
	src/drivers/stm32f4xx_rcc.c
	src/drivers/stm32f4xx_rng.c
	src/drivers/stm32f4xx_rtc.c
	src/drivers/stm32f4xx_sai.c
	src/drivers/stm32f4xx_sdio.c
	src/drivers/stm32f4xx_spdifrx.c
	src/drivers/stm32f4xx_spi.c
	src/drivers/stm32f4xx_syscfg.c
	src/drivers/stm32f4xx_tim.c
	src/drivers/stm32f4xx_usart.c
	src/drivers/stm32f4xx_wwdg.c
	src/stm32f407vg.S
)

add_library(stm32f4xx ${sources})

target_include_directories(stm32f4xx PUBLIC inc)
target_include_directories(stm32f4xx PUBLIC inc/cmsis)
target_include_directories(stm32f4xx PUBLIC inc/drivers)

target_compile_definitions(stm32f4xx PUBLIC USE_STDPERIPH_DRIVER)
target_compile_definitions(stm32f4xx PUBLIC ${DEVICE_FAMILY})
target_compile_definitions(stm32f4xx PUBLIC HSE_VALUE=8000000)

set(shared_options -Wall -Wextra -Os -nostartfiles)
target_compile_options(stm32f4xx PRIVATE ${shared_options})
target_link_libraries(stm32f4xx PRIVATE ${shared_options})

target_link_libraries(stm32f4xx PUBLIC -T${LINKER_SCRIPT})
