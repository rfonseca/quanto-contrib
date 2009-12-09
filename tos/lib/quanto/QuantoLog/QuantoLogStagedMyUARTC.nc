#include "RawUartMsg.h"

generic configuration QuantoLogStagedMyUARTC(uint8_t continuous) {
    provides interface QuantoLog;
}
implementation {
    components MainC;
    components new QuantoLogStagedMyUARTP(continuous) as QLog;
    QuantoLog =  QLog; 

    QLog.Boot -> MainC;

    components SingleActivityResourceTrackC;
    components MultiActivityResourceTrackC;
    components PowerStateTrackC;

    QLog.SingleActivityResourceTrack -> SingleActivityResourceTrackC;
    QLog.MultiActivityResourceTrack -> MultiActivityResourceTrackC;
    QLog.PowerStateTrack -> PowerStateTrackC;

    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;
    
    components MySerialSenderC as Serial;
    QLog.SerialControl -> Serial;
    QLog.UARTSend -> Serial.MySend;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;
}
