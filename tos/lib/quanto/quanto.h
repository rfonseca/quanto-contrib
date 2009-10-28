#ifndef __QUANTO_H_
#define __QUANTO_H_

#define QUANTO_ACTIVITY_IDS "quanto_activity_ids"
#define NEW_QUANTO_ACTIVITY_ID ((uint8_t) unique(QUANTO_ACTIVITY_IDS))
#define QUANTO_ACTIVITY(name) QUANTO_##name##_ACTIVITY_ID

#define QUANTO_RESOURCE_IDS "quanto_resource_ids"
#define NEW_QUANTO_RESOURCE_ID ((uint8_t) unique(QUANTO_RESOURCE_IDS))
#define QUANTO_RESOURCE(name) QUANTO_##name##_RESOURCE_ID



#endif //__QUANTO_H_

