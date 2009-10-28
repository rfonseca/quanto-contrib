#include "ActivitySet.h"

module TestIntegerSetC {
    uses interface Boot;
    uses interface Leds;
}
implementation {

   enum {
      A1 = NEW_QUANTO_ACTIVITY_ID,
      A2 = NEW_QUANTO_ACTIVITY_ID,
      A3 = NEW_QUANTO_ACTIVITY_ID,
      A4 = NEW_QUANTO_ACTIVITY_ID
   };

   ActivitySet actset;

   void task dummyTask() {
      return;
   }

    //capacity for this set is 200
    error_t testInsert() {
         uint8_t t[12] = {10,11,12,1,4,3,1,1,1,5,23,230};
         int i;
         uint8_t ok = 1;
         uint8_t count = 0;
         for (i = 0; i < 12; i++) {
            if (!activitySet_isMember(&actset, t[i]) &&
                t[i] < activitySet_capacity(&actset))
               count++; 
            activitySet_add(&actset, t[i]);
         }
         for (i = 0; i < 12; i++) {
            ok &= activitySet_isMember(&actset,t[i]) ||
                  t[i] >= activitySet_capacity(&actset);
         }
         ok &= (activitySet_numElements(&actset) == count);
         return ok?SUCCESS:FAIL;
    }

    error_t testClear() {
         uint8_t size = activitySet_capacity(&actset);
         uint8_t i;
         uint8_t ok = 1;
         activitySet_clear(&actset);
         for (i = 0; i < size; i++) {
            ok &= !(activitySet_isMember(&actset,i));
         }
         return ok?SUCCESS:FAIL;
    }

    /* Assumes this is called after testInsert() */
    error_t testRemove() {
        uint8_t t[8] = {10, 12, 3, 3, 4, 4, 8, 230};
        int i;
        uint8_t ok = 1;
        uint8_t remv = 0;
        uint8_t original = activitySet_numElements(&actset);
        for (i = 0; i < 8; i++) {
           if (activitySet_isMember(&actset, t[i]))
             remv++;
           activitySet_remove(&actset,t[i]);
        }
        for (i = 0; i < 8; i++) {
           ok &= !(activitySet_isMember(&actset,t[i]));
        }
        ok &= activitySet_isMember(&actset,1);
        ok &= activitySet_numElements(&actset) == original - remv;
        return ok?SUCCESS:FAIL;
    }


    event void Boot.booted()
    {
        error_t r;
        dbg("TC", "TestIntegerC Booted\n");
         
        activitySet_clear(&actset);
        dbg("TC", "activity set capacity: %d\n", activitySet_capacity(&actset));

        r = testInsert();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(1);
        dbg("TC", "testInsert() %s\n" , (r == SUCCESS)?"ok":"failed");

        r = testRemove();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(2);
        dbg("TC", "testRemove() %s\n" , (r == SUCCESS)?"ok":"failed");

        r = testClear();
        if (r == SUCCESS) call Leds.led1On();
        else call Leds.set(3);
        dbg("TC", "testClear() %s\n" , (r == SUCCESS)?"ok":"failed");

    }
}
