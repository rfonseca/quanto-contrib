#ifndef _RESOURCE_CONTEXTS_H
#define _RESOURCE_CONTEXTS_H

#include "quanto.h"

/* These are globally known resource ids */
/* Resources represent energy sinks, peripherals that can independently spend energy.
 * These are NOT activities, or contexts, but get attributed activities over time */

enum {
    QUANTO_RESOURCE(CPU) = NEW_QUANTO_RESOURCE_ID,

    QUANTO_RESOURCE(LED0)  = NEW_QUANTO_RESOURCE_ID,
    QUANTO_RESOURCE(LED1)  = NEW_QUANTO_RESOURCE_ID,
    QUANTO_RESOURCE(LED2)  = NEW_QUANTO_RESOURCE_ID,

    QUANTO_RESOURCE(SHT11)  = NEW_QUANTO_RESOURCE_ID,

    QUANTO_RESOURCE(CC2420)  = NEW_QUANTO_RESOURCE_ID,
    QUANTO_RESOURCE(CC2420_SPI)  = NEW_QUANTO_RESOURCE_ID,

    QUANTO_RESOURCE(MSP430_USART0)  = NEW_QUANTO_RESOURCE_ID,
    QUANTO_RESOURCE(MSP430_USART1)  = NEW_QUANTO_RESOURCE_ID,
};

#endif


