#include "MyVSerialWriter.h"
module MyVSerialWriterP {
   provides {
      interface PortWriter[uint8_t id];
      interface Init;
   }
   uses {
      interface PortWriter as LowerPortWriter;
      interface Init as LowerInit;
      interface SingleActivityResource as CPUResource;
      interface TaskQuanto as NextSend; 
   }
}
implementation {
   enum {
      NUM_CLIENTS = uniqueCount(V_SERIAL_CLIENT),
   };

   typedef struct {
      uint8_t* buf;
      uint16_t length;
   } entry_t;

   entry_t outstanding[NUM_CLIENTS];
   uint8_t current;

   command error_t Init.init() {
      uint8_t i;
      atomic {
         for (i = 0; i < NUM_CLIENTS; i++) {
            outstanding[i].buf = NULL;
            outstanding[i].length = 0;
            current = NUM_CLIENTS;
         }
      }
      return call LowerInit.init();
   } 

   async command error_t
   PortWriter.write[uint8_t id](uint8_t *buf, uint16_t len)
   {
      uint8_t to_send = 0;
      error_t err = SUCCESS;

      if (id >= NUM_CLIENTS || buf == NULL || len == 0) {
         return FAIL;
      }
      atomic {
         if (outstanding[id].buf != NULL) {
            return EBUSY;
         }
         outstanding[id].buf = buf;
         outstanding[id].length = len;
         //Is the queue empty? If not, we will get a writeDone
         //at which point we can take care of this write.
         to_send = (current >= NUM_CLIENTS); 
         if (to_send) {
            current = id;
            err = call LowerPortWriter.write(buf, len);
            if (err != SUCCESS) {
               current = NUM_CLIENTS;
               outstanding[id].buf = NULL;
               outstanding[id].length = 0;
            }
         }
      }
      return err;
   }

   //should be called inside an atomic block
   uint8_t nextPacket(uint8_t pos) {
      uint8_t p,i;
      p = 0;
      for (i = 1; i < NUM_CLIENTS; i++) {
         p = (i + pos) % NUM_CLIENTS;
         if (outstanding[p].buf != NULL) {
            break;
         }     
      }      
      if (i == NUM_CLIENTS) {
         return i;
      } else {
         return p;
      }
   }

   event void 
   LowerPortWriter.writeDone(uint8_t *buf, error_t result) 
   {
      uint8_t to_signal = NUM_CLIENTS;
      if (current >= NUM_CLIENTS) {
         return;
      } 
      if (outstanding[current].buf == buf) {
         to_signal = current;
         outstanding[current].buf = NULL;
         outstanding[current].length = 0;
         atomic {
            current = nextPacket(current);
            if (current < NUM_CLIENTS) {
               call NextSend.postTask(call CPUResource.get());
            }
         }
      } 
      if (to_signal != NUM_CLIENTS) {
         signal PortWriter.writeDone[to_signal](buf, result);
      }
   }
     
   event void NextSend.runTask() 
   {
      uint8_t pos;
      error_t result;
      //try to send current.
      atomic {
         pos = current;
      }
      result = call LowerPortWriter.write(outstanding[pos].buf, 
                                          outstanding[pos].length);
      if (result != SUCCESS) {
         signal PortWriter.writeDone[pos](outstanding[pos].buf, result);
         atomic {
            outstanding[pos].buf = NULL;
            outstanding[pos].length = 0;
            current = nextPacket(pos);
            if (current < NUM_CLIENTS) {
               call NextSend.postTask(call CPUResource.get());
            }
         }
      } 
   } 

   default event void
   PortWriter.writeDone[uint8_t id](uint8_t *buf, error_t result)
   {}
 
}
