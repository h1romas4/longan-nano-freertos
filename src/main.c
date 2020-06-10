#include "gd32vf103.h"
#include "systick.h"
#include <stdio.h>

#define LED_PIN_R GPIO_PIN_13
#define LED_PIN_G GPIO_PIN_1
#define LED_PIN_B GPIO_PIN_2

void longan_led_init()
{
    // enable the led clock
    rcu_periph_clock_enable(RCU_GPIOA);
    rcu_periph_clock_enable(RCU_GPIOC);

    // configure led GPIO port
    gpio_init(GPIOC, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ, LED_PIN_R);
    gpio_init(GPIOA, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ, LED_PIN_G);
    gpio_init(GPIOA, GPIO_MODE_OUT_PP, GPIO_OSPEED_50MHZ, LED_PIN_B);
}

void longan_rgb_led(uint8_t led)
{
    gpio_bit_write(GPIOC, LED_PIN_R, ((0b100 & led) >> 2) == 0 ? SET: RESET);
    gpio_bit_write(GPIOA, LED_PIN_G, ((0b010 & led) >> 1) == 0 ? SET: RESET);
    gpio_bit_write(GPIOA, LED_PIN_B, ((0b001 & led) >> 0) == 0 ? SET: RESET);
}

int main(void)
{
    longan_led_init();

    while(1) {
        /* turn on builtin led */
        for(uint8_t i = 0; i <= 7; i++) {
            longan_rgb_led(i);
            delay_1ms(200);
        }
    }
}
