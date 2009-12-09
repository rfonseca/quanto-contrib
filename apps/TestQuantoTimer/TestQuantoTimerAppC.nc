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
  TestQuantoTimerC.LED0Resource -> QuantoResourcesC.LED0Resource;
  TestQuantoTimerC.LED2Resource -> QuantoResourcesC.LED2Resource;
}
