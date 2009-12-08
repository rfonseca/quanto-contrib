configuration HplAdc12P {
  provides interface HplAdc12;
}
implementation
{
    components HplAdc12ImplP, QuantoResourcesC;
    HplAdc12P.CPUResource -> QuantoResourcesC.CPUResource;
    
    HplAdc12 = HplAdc12ImplP;
}
    
