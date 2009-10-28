/* Configuration to virtualize MySerialWriterC among more than one
 * client. */
#include "MyVSerialWriter.h"
generic configuration MyVSerialWriterClientC() 
{
   provides interface PortWriter;
}
implementation {
  components MyVSerialWriterC;
  PortWriter = MyVSerialWriterC.PortWriter[unique(V_SERIAL_CLIENT)]; 
}
