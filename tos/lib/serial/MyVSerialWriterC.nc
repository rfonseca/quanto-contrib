#include "MyVSerialWriter.h"
configuration MyVSerialWriterC {
   provides {
      interface PortWriter[uint8_t id];
      interface Init;
      interface SplitControl;
   }
}
implementation {
   components MySerialWriterC, MyVSerialWriterP;

   PortWriter = MyVSerialWriterP;
   Init = MyVSerialWriterP;
   SplitControl = MySerialWriterC;

   MyVSerialWriterP.LowerPortWriter -> MySerialWriterC;
   MyVSerialWriterP.LowerInit -> MySerialWriterC;

   components QuantoResourcesC, TinySchedulerC;
   MyVSerialWriterP.NextSend -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];
   MyVSerialWriterP.CPUResource -> QuantoResourcesC.CPUResource;
}
