#ifndef _ACTIVITY_SET_H
#define _ACTIVITY_SET_H

#include "quanto.h"



enum {
   ACT_SET_SIZE = uniqueCount(QUANTO_ACTIVITY_IDS),
};

typedef struct {
   uint8_t set[ACT_SET_SIZE/8 + 1];
   uint8_t elements;
} ActivitySet;

void activitySet_add(ActivitySet* aset, uint8_t element)
{
   uint8_t byte = element / 8;
   uint8_t mask = 1 << (element - (byte * 8));
   if (element >= ACT_SET_SIZE)
      return;
   if (!(aset->set[byte] & mask)) {
         aset->set[byte] |= mask;
         aset->elements++;
   }
}

void activitySet_remove(ActivitySet* aset, uint8_t element)
{
   uint8_t byte = element / 8;
   uint8_t mask = 1 << (element - (byte * 8));
   if (element >= ACT_SET_SIZE)
      return;
   if (aset->set[byte] & mask) {
         aset->set[byte] &= ~mask;
         aset->elements--;
   }
}

void activitySet_clear(ActivitySet* aset)
{
   memset(aset, 0, sizeof(*aset));
}

inline uint8_t activitySet_isMember(ActivitySet* aset, uint8_t element)
{
      uint8_t byte = element / 8;
      uint8_t mask = 1 << (element - (byte * 8));
      if (element >= ACT_SET_SIZE)
         return 0;
      return (aset->set[byte] & mask)?1:0;
}

inline uint8_t activitySet_numElements(ActivitySet* aset)
{
   return aset->elements;
}

inline uint8_t activitySet_capacity(ActivitySet* aset)
{
   return ACT_SET_SIZE;
}


#endif //_ACTIVITY_SET_H
