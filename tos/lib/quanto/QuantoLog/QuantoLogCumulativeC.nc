configuration QuantoLogCumulativeC {
}
implementation {
    components MainC,
              QuantoLogCumulativeP as QLog,
              TinySchedulerC,
              ActivityTypeP;
              
    QLog.Boot -> MainC;
    QLog.ReportTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];
    QLog.ActivityType -> ActivityTypeP;
      
    components SingleActivityResourceTrackC;

    QLog.SingleActivityResourceTrack -> SingleActivityResourceTrackC;

    components new MyVSerialWriterClientC() as SerialClient, 
               MyVSerialWriterC;
   
    QLog.PortWriter -> SerialClient;
    QLog.WriterInit -> MyVSerialWriterC;
    QLog.WriterControl -> MyVSerialWriterC;
//    components MySerialWriterC;
//    QLog.PortWriter -> MySerialWriterC;
//    QLog.WriterInit -> MySerialWriterC;
//    QLog.WriterControl -> MySerialWriterC;
     
    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;

}
