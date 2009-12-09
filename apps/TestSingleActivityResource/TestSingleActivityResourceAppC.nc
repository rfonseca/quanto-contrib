#include <Timer.h>

configuration TestSingleActivityResourceAppC
{
}
implementation
{
  components MainC, TestSingleActivityResourceC, LedsC, RandomC;
  components UserButtonC;
  components QuantoLogRawUARTC as CLog;
  components QuantoResourcesC;

  TestSingleActivityResourceC -> MainC.Boot;

  TestSingleActivityResourceC.Leds -> LedsC;
  TestSingleActivityResourceC.Random -> RandomC;
  TestSingleActivityResourceC.CPUResource -> QuantoResourcesC.CPUResource;
  TestSingleActivityResourceC.QuantoLog -> CLog;
  TestSingleActivityResourceC.UserButtonNotify -> UserButtonC;
}
