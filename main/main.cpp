#include "stm32f4xx.h"

// All of these belong to port D.
const uint16_t orangeLedPin = 13;
const uint16_t greenLedPin = 12;
const uint16_t redLedPin = 14;
const uint16_t blueLedPin = 15;

void enableGPIOD();
void enableOutputPin(GPIO_TypeDef* gpio, uint16_t pin);
void setPin(GPIO_TypeDef* gpio, uint16_t pin, bool value);

int main() {
	enableGPIOD();

	enableOutputPin(GPIOD, orangeLedPin);
	setPin(GPIOD, orangeLedPin, true);

	while (1);
}

void enableGPIOD() {
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;
}

void enableOutputPin(GPIO_TypeDef* gpio, uint16_t pin) {
	gpio->MODER |= 0b01 << (pin * 2);
}

void setPin(GPIO_TypeDef* gpio, uint16_t pin, bool value) {
	if (value) {
		gpio->BSRRL = 1 << pin;
	} else {
		gpio->BSRRH = 1 << pin;
	}
}