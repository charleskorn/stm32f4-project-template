#include "stm32f4xx.h"

// All of these belong to port D.
const uint16_t orangeLedPin = 13;
const uint16_t greenLedPin = 12;
const uint16_t redLedPin = 14;
const uint16_t blueLedPin = 15;

void enableGPIOD();
void enableOutputPin(GPIO_TypeDef* gpio, uint16_t pin);
void setPin(GPIO_TypeDef* gpio, uint16_t pin, bool value);
void enableTIM2();
void enableTimerUpdateInterrupt(TIM_TypeDef* tim);
void setPrescaler(TIM_TypeDef* tim, uint16_t prescaler);
uint32_t millisecondsToMicroseconds(uint32_t ms);
void setPeriod(TIM_TypeDef* tim, uint32_t value);
void enableAutoReload(TIM_TypeDef* tim);
void enableCounter(TIM_TypeDef* tim);
void resetTimer(TIM_TypeDef* tim);
void enableIRQ(IRQn_Type irq);
void resetTimerInterrupt(TIM_TypeDef* tim);

int main() {
	SystemInit();

	enableGPIOD();

	enableOutputPin(GPIOD, orangeLedPin);
	enableOutputPin(GPIOD, greenLedPin);
	enableOutputPin(GPIOD, redLedPin);
	enableOutputPin(GPIOD, blueLedPin);
	setPin(GPIOD, blueLedPin, true);

	enableTIM2();
	enableIRQ(TIM2_IRQn);
	enableTimerUpdateInterrupt(TIM2);
	setPrescaler(TIM2, 16 - 1); // Set scale to microseconds, based on a 16 MHz clock
	setPeriod(TIM2, millisecondsToMicroseconds(1000) - 1);
	enableAutoReload(TIM2);
	enableCounter(TIM2);
	resetTimer(TIM2);

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

void enableTIM2() {
	RCC->APB1ENR |= RCC_APB1ENR_TIM2EN;
}

void enableTimerUpdateInterrupt(TIM_TypeDef* tim) {
	tim->DIER |= TIM_DIER_UIE;
}

// Note: according to section 18.4.11 of the reference manual, there's a +1 on the value in the prescaler.
// So, for example, setting the prescaler to 10 has the effect of dividing the clock by 11.
void setPrescaler(TIM_TypeDef* tim, uint16_t prescaler) {
	tim->PSC = prescaler;
}

uint32_t millisecondsToMicroseconds(uint32_t ms) {
	return ms * 1000;
}

void setPeriod(TIM_TypeDef* tim, uint32_t value) {
	tim->ARR = value;
}

void enableAutoReload(TIM_TypeDef* tim) {
	tim->CR1 |= TIM_CR1_ARPE;
}

void enableCounter(TIM_TypeDef* tim) {
	tim->CR1 |= TIM_CR1_CEN;
}

void resetTimer(TIM_TypeDef* tim) {
	tim->EGR |= TIM_EGR_UG;
}

void enableIRQ(IRQn_Type irq) {
	NVIC_EnableIRQ(irq);
}

void resetTimerInterrupt(TIM_TypeDef* tim) {
	tim->SR = 0;
}

extern "C" {
	void TIM2_IRQHandler() {
		if (TIM2->SR & TIM_SR_UIF) {
			GPIOD->ODR ^= 1 << orangeLedPin;
		}

		resetTimerInterrupt(TIM2);
	}
}