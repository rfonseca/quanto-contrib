#include <Timer.h>

configuration TestQuantoTimerAppC
{
}
implementation
{
  components MainC, TestQuantoTimerC, LedsC, RandomC;
  components UserButtonC;
  components QuantoLogRawUARTC as CLog;
  components QuantoResourcesC;
  components new TimerMilliC() as TimerA;
  components new TimerMilliC() as TimerB;

  TestQuantoTimerC -> MainC.Boot;

  TestQuantoTimerC.Leds -> LedsC;
  TestQuantoTimerC.Random -> RandomC;
  TestQuantoTimerC.UserButtonNotify -> UserButtonC;
  TestQuantoTimerC.TimerA -> TimerA;
  TestQuantoTimerC.TimerB -> TimerB;
  TestQuantoTimerC.QuantoLog -> CLog;
  TestQuantoTimerC.CPUResource -> QuantoResourcesC.CPUResource;
  TestQuantoTimerC.Led0Resource -> QuantoResourcesC.Led0Resource;
  TestQuantoTimerC.Led2Resource -> QuantoResourcesC.Led2Resource;
}
