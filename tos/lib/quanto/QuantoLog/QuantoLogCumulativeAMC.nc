configuration QuantoLogCumulativeAMC {
}
implementation {
    components MainC,
              QuantoLogCumulativeAMP as QLog,
              TinySchedulerC,
              ActivityTypeP;
              
    QLog.Boot -> MainC;
    QLog.ReportTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];
    QLog.ActivityType -> ActivityTypeP;
      
    components SingleContextTrackC;

    QLog.SingleActivityResourceTrack -> SingleContextTrackC;

    components SerialActiveMessageC as AM;
    QLog.WriterControl -> AM;
    QLog.AMSend -> AM.AMSend[0xBB];
    QLog.Packet -> AM;
     
    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;

}
