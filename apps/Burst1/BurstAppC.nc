configuration BurstAppC {
}
implementation {
    components
            MainC,
            BurstC,
            LedsC,
            UserButtonC,
            QuantoLogRawUARTC as CLog,
            QuantoResourcesC;

    BurstC.Boot -> MainC.Boot;
    BurstC.Leds -> LedsC;
    BurstC.CPUResource -> QuantoResourcesC.CPUResource;
    BurstC.UserButtonNotify -> UserButtonC;
    BurstC.QuantoLog -> CLog;
}
