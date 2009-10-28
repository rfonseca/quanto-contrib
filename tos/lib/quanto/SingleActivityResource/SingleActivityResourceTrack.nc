
#include "activity.h"

/** Authors: Rodrigo Fonseca, Prabal Dutta, and Jay Taneja */

interface SingleActivityTrack {
    /** Event signaled when the activity changes */
    async event void changed(act_t oldActivity, act_t newActivity);

    /* CPU Only */

    /** Event signaled when the context changes by binding an
     *  old activity to a new activity */
    async event void bound(act_t oldActivity, act_t newActivity);

    async event void enteredInterrupt(act_t oldActivity, act_t newActivity);

    async event void exitedInterrupt(act_t oldActivity, act_t newActivity);

}

