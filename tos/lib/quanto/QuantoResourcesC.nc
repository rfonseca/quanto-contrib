#include "QuantoResources.h"
/* Centralized component to offer Single and MultiActivityResource interfaces
 * for different resources.  New resources don't have to use this component,
 * but in the whole system there can be only one instantiation of
 * SingleActivityResourceC for each QUANTO_RESOURCE() value.
 */
configuration QuantoResourcesC {
    provides {
        interface SingleActivityResource as CPUResource;

        interface MultiActivityResource as Led0Resource;
        interface MultiActivityResource as Led1Resource;
        interface MultiActivityResource as Led2Resource;

        //interface MultiActivityResource as CC2420RxResource;
        //interface SingleActivityResource as CC2420TxResource;
        interface SingleActivityResource as CC2420Resource;
        interface SingleActivityResource as CC2420SpiResource;
        interface SingleActivityResource as Msp430Usart0Resource;
        interface SingleActivityResource as Msp430Usart1Resource;

        interface SingleActivityResource as Sht11Resource;
        //add more resources here...
    
        interface PowerState as CPUPowerState;
        interface PowerState as CC2420PowerState;
        interface PowerState as Led0PowerState;
        interface PowerState as Led1PowerState;
        interface PowerState as Led2PowerState;
    }
} 
implementation {
    components new SingleActivityResourceC(QUANTO_RESOURCE(CPU)) as CPU;
    CPUResource = CPU;

    components new SingleActivityResourceC(QUANTO_RESOURCE(CC2420)) as CC2420Res;
    CC2420Resource = CC2420Res;

    components new SingleActivityResourceC(QUANTO_RESOURCE(CC2420_SPI)) as CC2420SpiRes;
    CC2420SpiResource = CC2420SpiRes;

    components new SingleActivityResourceC(QUANTO_RESOURCE(MSP430_USART0)) as Msp430Usart0Res;
    Msp430Usart0Resource = Msp430Usart0Res;

    components new SingleActivityResourceC(QUANTO_RESOURCE(MSP430_USART1)) as Msp430Usart1Res;
    Msp430Usart1Resource = Msp430Usart1Res;

    components new MultiActivityResourceC(QUANTO_RESOURCE(LED0)) as Led0;
    Led0Resource = Led0;

    components new MultiActivityResourceC(QUANTO_RESOURCE(LED1)) as Led1;
    Led1Resource = Led1;

    components new MultiActivityResourceC(QUANTO_RESOURCE(LED2)) as Led2;
    Led2Resource = Led2;

    components new SingleActivityResourceC(QUANTO_RESOURCE(SHT11)) as Sht11;
    Sht11Resource = Sht11;

    components new PowerStateC(QUANTO_RESOURCE(CC2420)) as CC2420Power;
    CC2420PowerState = CC2420Power;

    components new PowerStateC(QUANTO_RESOURCE(LED0)) as Led0Power;
    Led0PowerState = Led0Power;

    components new PowerStateC(QUANTO_RESOURCE(LED1)) as Led1Power;
    Led1PowerState = Led1Power;

    components new PowerStateC(QUANTO_RESOURCE(LED2)) as Led2Power;
    Led2PowerState = Led2Power;

    components new PowerStateC(QUANTO_RESOURCE(CPU)) as CPUPower;
    CPUPowerState = CPUPower;

}
