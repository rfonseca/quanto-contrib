configuration HplMsp430InterruptNMIP {
  provides interface HplMsp430Interrupt as NMI;
  provides interface HplMsp430Interrupt as OF;
  provides interface HplMsp430Interrupt as ACCV;
}
implementation {
    components HplMsp430InterruptNMIImplP, QuantoResourcesC;
    HplMsp430InterruptNMIImplP.CPUResource -> QuantoResourcesC.CPUResource;

    NMI = HplMsp430InterruptNMIImplP;
    OF = HplMsp430InterruptNMIImplP;
    ACCV = HplMsp430InterruptNMIImplP;
}   
