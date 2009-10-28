#ifndef _QUANTO_RESOURCES_H
#define _QUANTO_RESOURCES_H
/* These are globally known resource ids */
/* Resources represent energy sinks, peripherals that can independently spend energy.
 * These are NOT activities, or contexts, but get attributed activities over time */

#define QUANTO_RESOURCE_IDS "quanto_resource_ids"
#define NEW_QUANTO_RESOURCE_ID ((uint8_t) unique(QUANTO_RESOURCE_IDS))

enum {
    CPU_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,

    LED0_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,
    LED1_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,
    LED2_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,

    SHT11_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,

    CC2420_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,
    CC2420_SPI_RESOURCE_ID = NEW_QUANTO_RESOURCE_ID,

    MSP430_USART0_ID = NEW_QUANTO_RESOURCE_ID,
    MSP430_USART1_ID = NEW_QUANTO_RESOURCE_ID,
};
#endif


