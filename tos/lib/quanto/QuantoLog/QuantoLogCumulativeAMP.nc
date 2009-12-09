#include "QuantoLogCumulative.h"

module QuantoLogCumulativeAMP {
   uses {
      interface SingleActivityResourceTrack as SingleActivityResourceTrack[uint8_t res_id];
      interface ActivityType;
      interface Counter<T32khz,uint32_t> as Counter;
      interface TaskQuanto as ReportTask;
      interface AMSend;
      interface Packet;

      interface Boot;
      //interface Init as WriterInit;
      interface SplitControl as WriterControl;
   }
}
implementation {

/* At every interval of at least X, dump the table to the UART
 * Use double buffering and swap the pointer
 */

   /*
    * This module counts all activities by other nodes as
    * a single activity. We create a new activity id,
    * OTHER_NODE, which is never set, but will have a 
    * slot and be reported. 
    * We use a double buffer to snapshot the timings for
    * a slot and then lock it for sending, while accepting
    * updates to the other slot.
    * The module sends updates every second, and has up to
    * 1 second to write these to the UART. We use a timer
    * that ticks at 32768 Hz, so we can safely use a 16-bit
    * integer to represent deltas in the interval.
    */
   
   enum {
      QUANTO_ACTIVITY(OTHER_NODE) = NEW_QUANTO_ACTIVITY_ID,

      RESOURCE_COUNT = uniqueCount(QUANTO_RESOURCE_IDS),

      REPORT_INTERVAL = 32768u,
      NO_BIND = 0,
      BIND    = 1,
   };

   norace static act_t act_quanto_log;

   uint8_t    m_slot;                           //double buffer index
   uint8_t    m_report_pending;                 //inactive buffer guard.
   uint32_t   m_slot_start[2];                  //time when we started recording at this slot
   act_type_t m_current_act[RESOURCE_COUNT]; //current activity for each resource
   uint32_t   m_last_time[RESOURCE_COUNT];   //time of last switch for each resource

   ctime_msg_t* m_header_msg;
   ctime_msg_t* m_body_msg;
   message_t* m_buf;

   message_t h_packet;
   message_t b_packet;

   /* This is the main data structure in the module, which stores,
    * for this epoch, the total time spent by each resource on
    * behalf of each activity. */

   uint16_t   m_time[2][RESOURCE_COUNT][ACT_COUNT];


   //should be called inside atomic
   inline void switch_slot() {
      m_slot = 1 - m_slot;
   }

   //should be called inside atomic
   inline void clearSlot(uint8_t i) {
      memset(m_time[i], 0, sizeof(m_time[i]));
   }

   event void Boot.booted() {
      uint8_t i;
      act_quanto_log = mk_act_local(QUANTO_ACTIVITY(QUANTO_WRITER));
      atomic {
         clearSlot(0);
         clearSlot(1);
         m_slot = 0;
         m_slot_start[0] = 0;
         m_slot_start[1] = 0;
         m_report_pending = 0;
         for (i = 0; i < RESOURCE_COUNT; i++) {
            m_last_time[i] = 0;
            m_current_act[i] = QUANTO_ACTIVITY(UNKNOWN);
         }
      }
      m_header_msg = (ctime_msg_t*)call Packet.getPayload(&h_packet, sizeof(ctime_msg_t));
      m_body_msg   = (ctime_msg_t*)call Packet.getPayload(&b_packet, sizeof(ctime_msg_t));

      //init header message with fields that won't change
      m_header_msg->type = TYPE_CTIME_HEADER;
      m_header_msg->header.res_count = RESOURCE_COUNT;
      m_header_msg->header.act_count = ACT_COUNT;
      for (i = 0; i < (ACT_COUNT); i++) {
         m_header_msg->header.act_ids[i] = i;
         m_header_msg->header.first_bind[i] = QUANTO_ACTIVITY(UNKNOWN); 
      }
      //m_header_msg->header.act_ids[ACT_COUNT-1] = QUANTO_ACTIVITY(UNKNOWN);
      //init body msg
      m_body_msg->type = TYPE_CTIME_BODY;

      //call WriterInit.init();
      call WriterControl.start();
   }

    event void WriterControl.startDone(error_t result) {
        if (result != SUCCESS) {
            call WriterControl.start();
            return;
        }
    }

    event void WriterControl.stopDone(error_t result) {
    }
 

   void 
   recordChange(uint8_t res_id, act_t oldActivity, act_t newActivity, bool bind)
   {
      //TODO: we are ignoring bind for now
      uint16_t node = call ActivityType.getNode(&newActivity);
      act_type_t act = call ActivityType.getActType(&newActivity); 
      uint32_t now = call Counter.get();
      uint16_t delta;
      uint8_t to_report = 0;
      uint8_t i;
      uint8_t res;

 
      //get the index for the activity
      if (node != TOS_NODE_ID) {
         act = QUANTO_ACTIVITY(OTHER_NODE);
      }
      
      atomic {
         delta = (uint16_t)(now - m_last_time[res_id]);
         m_time[m_slot][res_id][m_current_act[res_id]] += delta;

         m_last_time[res_id] = now;
         m_current_act[res_id] = act;
         
         to_report = (!m_report_pending && ((now - m_slot_start[m_slot]) > REPORT_INTERVAL) );
         if (to_report) {
            m_report_pending = RESOURCE_COUNT + 1;
            //close the times for all resources but res_id (which is already closed)
            for (i = 1; i < RESOURCE_COUNT; i++) {
               res = (res_id + i) % RESOURCE_COUNT; 
               m_time[m_slot][res][m_current_act[res]] += (uint16_t)(now - m_last_time[res]);
               m_last_time[res] = now;
            }
            switch_slot();
            m_slot_start[m_slot] = now;
         }
      }
      if (to_report) {
         call ReportTask.postTask(act_quanto_log);
      }
   }

   inline void fillBodyMsg(uint8_t slot, uint8_t res) {
      uint8_t i;
      m_body_msg->body.res_id = res;
      atomic {
         for (i = 0; i < ACT_COUNT; i++) {
            m_body_msg->body.time[i] = m_time[slot][res][i]; 
         }   
      }
   }

   /* ReportTask */
   event void ReportTask.runTask()
   {
      uint8_t c;
      uint8_t r_slot;
      uint8_t res;
      uint32_t t_start, t_end;
      uint16_t len = sizeof(ctime_body_t) + 1;

      atomic{
         c = m_report_pending;
         r_slot = 1 - m_slot; // the slot that's not active
         t_start = m_slot_start[r_slot];
         t_end   = m_slot_start[1 - r_slot];
      }
      if (c == RESOURCE_COUNT + 1) {
         //send header
         m_header_msg->header.time_base = t_start;
         m_header_msg->header.total_time = (uint16_t)(t_end - t_start);
         m_buf = &h_packet;//m_header_msg;
         len = sizeof(ctime_header_t) + 1;
      }
      else if (c >= 1) {
         //send body
         res = RESOURCE_COUNT - c;
         fillBodyMsg(r_slot, res);
         m_buf = &b_packet;//m_body_msg;
      }   
      //cleanup slot for next time
      if (c == 1) {
         atomic clearSlot(r_slot);
      }
      res = call AMSend.send(AM_BROADCAST_ADDR, m_buf, (uint8_t)len);
      if (res != SUCCESS) {
      }
   }

   event void AMSend.sendDone(message_t *buf, error_t result)
   {
      uint8_t c;
      if (buf == m_buf) {
         atomic {
            c = --m_report_pending;
         }
         if (c) {
            call ReportTask.postTask(act_quanto_log);
         }
      }
   } 

   async event void
   SingleActivityResourceTrack.changed[uint8_t res_id](
                                             act_t oldActivity, 
                                             act_t newActivity)
   {
      recordChange(res_id, oldActivity, newActivity, NO_BIND);
   }

   async event void 
   SingleActivityResourceTrack.bound[uint8_t res_id](
                                             act_t oldActivity, 
                                             act_t newActivity)
   {
      recordChange(res_id, oldActivity, newActivity, BIND);
   }

   async event void 
   SingleActivityResourceTrack.enteredInterrupt[uint8_t res_id](
                                             act_t oldActivity, 
                                             act_t newActivity)
   {
      recordChange(res_id, oldActivity, newActivity, NO_BIND);
   }

   async event void 
   SingleActivityResourceTrack.exitedInterrupt[uint8_t res_id](
                                             act_t oldActivity, 
                                             act_t newActivity)
   {
      recordChange(res_id, oldActivity, newActivity, NO_BIND);
   }

   
    //subtraction should work even on overflow
    async event void Counter.overflow() {}

}
