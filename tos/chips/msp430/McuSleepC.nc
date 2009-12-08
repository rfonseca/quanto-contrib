configuration McuSleepC {
    provides {
        interface McuSleep;
        interface McuPowerState;
    }
  uses {
    interface McuPowerOverride;
  }
}
implementation {
    components McuSleepP, QuantoResourcesC;

    McuSleep = McuSleepP;
    McuPowerState = McuSleepP;
    McuPowerOverride = McuSleepP;
        
    McuSleepP.CPUPowerState -> QuantoResourcesC.CPUPowerState;

}
