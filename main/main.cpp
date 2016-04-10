#include "stm32f4xx.h"

int main() {
	while (1);
}

extern "C" {
	void _exit() {
		while (1);
	}
}
