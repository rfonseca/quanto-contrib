#include "activity.h"

/** Authors: Rodrigo Fonseca, Prabal Dutta, and Jay Taneja */

interface SingleActivityResource {
    /** Returns the current activity */
    async command act_t getActivity();

    /** Sets the current activity */
    async command void  setActivity(act_t newActivity);

    /** Sets the current activity with local node
     *  and activity type 'newAct' 
     */
    async command void  setLocalActivity(act_type_t newAct);

    /** Sets the current activity to unknown */
    async command void setUnknownActivity();
    /** Sets the current activity to invalid */
    async command void setInvalidActivity();
    /** sets the current activity to idle */
    async command void setIdle();

    /** Whether the current activity is valid */
    async command bool  isValidActivity();

    /****** These only really apply to the CPU  ***********/

    /** Indicates a change in activity AND that the old activity is
     *  to be bound to the new one. This means that the 
     *  accounting of the previous activity is to be attributed to
     *  the new activity.
     *  
     */
    async command void bindActivity(act_t newActivity);

    /** Called at the start of an interrupt handler.
     *  This works in a pair with exitInterrupt. Both functions
     *  assume that the handler will restore the old activity
     *  before returning.
     *  This command MUST override the node part of newActivity with
     *  TOS_NODE_ID
     *
     *  @param newActivity the (proxy) activity entered at the interrupt
     *                    handler. 
     *  @return the previous activity to be restored later.
     */
    async command act_t enterInterrupt(act_t newActivity);

    /** Called before the end of an interrupt handler. If the
     *  restore activity is _idle_, this function doesn't register
     *  change. This is because the task loop will do so
     *  appropriately.
     *  @param restoreActivity the old activity to be restored after the
     *                        handler returns. This is kept as a stack
     *                        variable by the handler.
     */
    async command void   exitInterrupt(act_t restoreActivity);

    /** Forces an exitInterrupt returning the activity to idle. 
     *  This should be called by the scheduler, on the first time
     *  after waking up from an interrupt.
     */
    async command void   exitInterruptIdle();

}

