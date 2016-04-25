#include <stdio.h>
#include "bandit/bandit.h"
#include "stm32f4xx.h"

const uint16_t greenLedPin = 12;
const uint16_t orangeLedPin = 13;
const uint16_t redLedPin = 14;
const uint16_t blueLedPin = 15;

void enableGPIOD();
void enableOutputPin(GPIO_TypeDef *gpio, uint16_t pin);
void setupLEDs();
void setOutputPin(GPIO_TypeDef *gpio, uint16_t pin, BitAction value);
bool runTests();

extern "C" {
    extern void initialise_monitor_handles();
}

void main() {
    setupLEDs();

    setOutputPin(GPIOD, orangeLedPin, Bit_SET);
    initialise_monitor_handles();
    setOutputPin(GPIOD, orangeLedPin, Bit_RESET);

    setOutputPin(GPIOD, blueLedPin, Bit_SET);
    bool testsPassed = runTests();
    setOutputPin(GPIOD, blueLedPin, Bit_RESET);

    if (testsPassed) {
        setOutputPin(GPIOD, greenLedPin, Bit_SET);
    } else {
        setOutputPin(GPIOD, redLedPin, Bit_SET);
    }
}

void setupLEDs() {
    enableGPIOD();

    enableOutputPin(GPIOD, greenLedPin);
    enableOutputPin(GPIOD, orangeLedPin);
    enableOutputPin(GPIOD, redLedPin);
    enableOutputPin(GPIOD, blueLedPin);
}

void enableGPIOD() {
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;
}

void enableOutputPin(GPIO_TypeDef *gpio, uint16_t pin) {
    gpio->MODER |= GPIO_Mode_OUT << (pin * 2);
}

void setOutputPin(GPIO_TypeDef *gpio, uint16_t pin, BitAction value) {
    GPIO_WriteBit(gpio, 1 << pin, value);
}

bool runTests() {
    bandit::detail::options opt(0, {});
    bandit::detail::default_failure_formatter formatter;
    bandit::detail::colorizer colorizer(true);
    bandit::detail::dots_reporter reporter(formatter, colorizer);

    bandit::detail::register_listener(&reporter);

    bandit::detail::run_policy_ptr run_policy(new bandit::detail::always_run_policy());
    register_run_policy(run_policy.get());

    bandit::run(opt, bandit::detail::specs(), bandit::detail::context_stack(), reporter);

    return reporter.did_we_pass();
}
