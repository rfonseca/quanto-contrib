#ifndef _ACTIVITY_SET_H
#define _ACTIVITY_SET_H

enum {
   ACT_SET_SIZE = uniqueCount(QUANTO_ACTIVITY_IDS),
};

typedef struct {
   uint8_t set[ACT_SET_SIZE/8 + 1];
   uint8_t elements;
} activitySet;

void activitySet_add(activtySet* as, uint8_t element)
{
   uint8_t byte = element / 8;
   uint8_t mask = 1 << (element - (byte * 8));
   if (element > ACT_SET_SIZE)
      return;
   if (!(as->set[byte] & mask)) {
         as->set[byte] |= mask;
         as->elements++;
   }
}

void activitySet_remove(activitySet* as, uint8_t element)
{
   uint8_t byte = element / 8;
   uint8_t mask = 1 << (element - (byte * 8));
   if (element > ACT_SET_SIZE)
      return;
   if (as->set[byte] & mask) {
         as->set[byte] &= ~mask;
         as->elements--;
   }
}

void activitySet_clear(activitySet* as)
{
   memset(as, 0, sizeof(*as));
}

inline uint8_t activitySet_isMember(activitySet* as, uint8_t element)
{
      uint8_t byte = element / 8;
      uint8_t mask = 1 << (element - (byte * 8));
      if (element > ACT_SET_SIZE)
         return 0;
      return (as->set[byte] & mask)?1:0;
}

inline uint8_t activitySet_numElements(activitySet* as)
{
   return as->elements;
}


#endif //_ACTIVITY_SET_H
