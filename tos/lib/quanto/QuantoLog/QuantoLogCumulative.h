#ifndef _QUANTO_LOG_CUMULATIVE_H
#define _QUANTO_LOG_CUMULATIVE_H
#include "RawUartMsg.h" //for MSG_TYPE_OFFSET
#include "../quanto.h"   //for QUANTO_ACTIVITY_IDS

/* Message formats for the cumulative quanto log.
 * The cumulative log has information on how much *time* each
 * *resource* was working on behalf of each *activity*.
 *
 * This is complementary to the power information, which has
 * information on how long the platform spent on each *power state*
 * and how much energy was spent in each of these intervals.
 * 
 * There are two subtypes currently defined, ctime_header_t and
 * ctime_body_t, corresponding to CTIME_HEADER and CTIME_BODY
 * messages.
 * 
 * The log is structured as follows: every interval T, the logger
 * will send a HEADER message followed by several BODY
 * messages. There is one BODY message per *resource*. The
 * number of resources is indicated in the HEADER message.
 * Each BODY message will have a resource id followed by a list of
 * time values. Each value corresponds to how long in this interval
 * the resource was working on behalf of an activity. The number of
 * activities in each BODY message, as well as their ids, are sent
 * in the immediately preceeding HEADER message.
 * 
 * first_bind: when an activity change is bind, the time consumed
 *             on the previous activity is transferred to the new
 *             one. However, if the previous activity started in the
 *             previous logged interval, we will be missing the time
 *             on that. For that, we need to link the two by 
 */

enum {
   MSG_TYPE_CTIME = 5,
   
   CTIME_HEADER = 1,
   CTIME_BODY = 2,

   TYPE_CTIME_HEADER = (MSG_TYPE_CTIME << MSG_TYPE_OFFSET) | CTIME_HEADER,
   TYPE_CTIME_BODY   = (MSG_TYPE_CTIME << MSG_TYPE_OFFSET) | CTIME_BODY,
   
   ACT_COUNT = uniqueCount(QUANTO_ACTIVITY_IDS),
};

/* A ctime_header_t message corresponds to a time interval, and is 
   followed by one or more ctime_body_t messages. */
typedef nx_struct ctime_header_t {
   nx_uint32_t time_base;            //start of interval (tics)
   nx_uint16_t total_time;           //duration of interval (tics)
   nx_uint8_t res_count;             //resources: number of following body messages
   nx_uint8_t act_count;             //activities: number of activities on each body msg
   nx_uint8_t act_ids[ACT_COUNT];    //ids of the activities, in order
   nx_uint8_t first_bind[ACT_COUNT]; //
} ctime_header_t;  

typedef nx_struct ctime_body_t {
   nx_uint8_t res_id;               //resource id for this report line
   nx_uint16_t time[ACT_COUNT];     //time spent by the resource on behalf of each activity.
                                    // Actitivies follow the order
                                    // and ids in the header message.
} ctime_body_t;

typedef nx_struct ctime_msg_t {
   nx_uint8_t type;
   nx_union {
      ctime_header_t header;
      ctime_body_t body;
   };
} ctime_msg_t;

#endif //_QUANTO_LOG_CUMULATIVE_H

