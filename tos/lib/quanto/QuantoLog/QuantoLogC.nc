configuration QuantoLogC {
    provides interface QuantoLog;
}
implementation {
    components QuantoLogP;
    QuantoLog =  QuantoLogP; 

    components SingleActivityResourceTrackC;
    components MultiActivityResourceTrackC;
    components PowerStateTrackC;
    QuantoLogP.SingleActivityResourceTrack -> SingleActivityResourceTrackC;
    QuantoLogP.MultiActivityResourceTrack -> MultiActivityResourceTrackC;

    components DebugC;
    QuantoLogP.Debug -> DebugC;

    components LedsC;
    QuantoLogP.Leds  ->  LedsC;
    
    components new TimerMilliC() as  ReportTimer;
    QuantoLogP.ReportTimer -> ReportTimer;
   
    components Counter32khz32C as Counter;
    QuantoLogP.Counter -> Counter;
}
