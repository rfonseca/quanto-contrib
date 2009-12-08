configuration HplMsp430DmaP {
  provides interface HplMsp430DmaControl as DmaControl;
  provides interface HplMsp430DmaInterrupt as Interrupt;
}
implementation {
    components HplMsp430DmaImplP, QuantoResourcesC;
    HplMsp430DmaImplP.CPUResource -> QuantoResourcesC.CPUResource;

    DmaControl = HplMsp430DmaImplP;
    Interrupt  = HplMsp430DmaImplP;
}
