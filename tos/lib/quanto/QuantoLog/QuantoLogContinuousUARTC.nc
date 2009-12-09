#include "RawUartMsg.h"

configuration QuantoLogContinuousUARTC {
    provides interface QuantoLog;
}
implementation {
    components MainC;
    components QuantoLogContinuousUARTP as QLog;
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
    
    components SerialActiveMessageC as Serial;
    components new SerialAMSenderC(QUANTO_LOG_AM_TYPE) as UARTSender;
    QLog.SerialControl -> Serial;
    QLog.UARTSend -> UARTSender;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;

    components LedsC;
    QLog.Leds -> LedsC;
}
