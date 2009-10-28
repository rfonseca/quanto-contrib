#include "QuantoResources.h"
/* Centralized component to offer QuantoResource interfaces for different
 * resources. Although new resources don't have to use this component,
 * applications MUST NOT instantiate the generic SingleActivityResourceC directly.
 * In the whole system there can be only one instantiation of SingleActivityResourceC
 * for each ...RESOURCE_ID value.
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
    components new SingleActivityResourceC(CPU_RESOURCE_ID) as CPU;
    CPUResource = CPU;

    components new SingleActivityResourceC(CC2420_RESOURCE_ID) as CC2420Res;
    CC2420Resource = CC2420Res;

    components new SingleActivityResourceC(CC2420_SPI_RESOURCE_ID) as CC2420SpiRes;
    CC2420SpiResource = CC2420SpiRes;

    components new SingleActivityResourceC(MSP430_USART0_ID) as Msp430Usart0Res;
    Msp430Usart0Resource = Msp430Usart0Res;

    components new SingleActivityResourceC(MSP430_USART1_ID) as Msp430Usart1Res;
    Msp430Usart1Resource = Msp430Usart1Res;

    components new MultiActivityResourceC(LED0_RESOURCE_ID) as Led0;
    Led0Resource = Led0;

    components new MultiActivityResourceC(LED1_RESOURCE_ID) as Led1;
    Led1Resource = Led1;

    components new MultiActivityResourceC(LED2_RESOURCE_ID) as Led2;
    Led2Resource = Led2;

    components new SingleActivityResourceC(SHT11_RESOURCE_ID) as Sht11;
    Sht11Resource = Sht11;

    components new PowerStateC(CC2420_RESOURCE_ID) as CC2420Power;
    CC2420PowerState = CC2420Power;

    components new PowerStateC(LED0_RESOURCE_ID) as Led0Power;
    Led0PowerState = Led0Power;

    components new PowerStateC(LED1_RESOURCE_ID) as Led1Power;
    Led1PowerState = Led1Power;

    components new PowerStateC(LED2_RESOURCE_ID) as Led2Power;
    Led2PowerState = Led2Power;

    components new PowerStateC(CPU_RESOURCE_ID) as CPUPower;
    CPUPowerState = CPUPower;

}
