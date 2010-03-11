configuration QuantoLogMyUartWriterC {
}
implementation {
    components MainC;
    components QuantoLogMyUartWriterP as QLog;
    components TinySchedulerC;

    QLog.Boot -> MainC;
    QLog.PrepareWriteTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];

    //components PortWriterC;
    //components MySerialWriterC;
    components new MyVSerialWriterClientC() as SerialClient, MyVSerialWriterC;
   
    QLog.PortWriter -> SerialClient;    
    QLog.WriterInit -> MyVSerialWriterC;
    QLog.WriterControl -> MyVSerialWriterC;
    

    components SingleActivityResourceTrackC;
    components MultiActivityResourceTrackC;
    components PowerStateTrackC;

    //QLog.SingleActivityResourceTrack -> SingleActivityResourceTrackC;
    QLog.MultiActivityResourceTrack -> MultiActivityResourceTrackC;
    QLog.PowerStateTrack -> PowerStateTrackC;

    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;

}
