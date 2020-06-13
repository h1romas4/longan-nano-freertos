#include "FreeRTOS.h"
#include "task.h"

#include "gd32vf103.h"

#define LED_PIN_R GPIO_PIN_13
#define LED_PIN_G GPIO_PIN_1
#define LED_PIN_B GPIO_PIN_2

#define TASK_PRIORITY 1

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

void task1(void *param)
{
    longan_led_init();
    // blue led
    longan_rgb_led(1);
    // NOT WORKING
    vTaskDelay(1);
    // red led
    longan_rgb_led(2);
}

int main(void)
{
    /* Create any tasks defined within main.c itself, or otherwise specific to the
       demo being built. */
    xTaskCreate(task1, "task1", configMINIMAL_STACK_SIZE * 2, NULL, TASK_PRIORITY, NULL);

    /* Start the RTOS scheduler, this function should not return as it causes the
       execution context to change from main() to one of the created tasks. */
    vTaskStartScheduler();

    /* Should never get here! */
    return 0;
}
