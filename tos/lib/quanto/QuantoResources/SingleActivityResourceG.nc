/* mapping between global and local id spaces */
/* @see SingleActivityResourceC for wiring */

module SingleActivityResourceG {
    provides interface SingleActivityResource[uint8_t id];
    provides interface SingleActivityResourceTrack[uint8_t id];
    uses interface SingleActivityResource as SingleActivityResourceLocal[uint8_t id];
    uses interface SingleActivityResourceTrack as SingleActivityResourceTrackLocal[uint8_t id];
}
implementation {
    inline async command act_t 
    SingleActivityResource.get[uint8_t id]() 
    {
        return call SingleActivityResourceLocal.get[id]();
    }

    inline async command void  
    SingleActivityResource.set[uint8_t id](act_t newActivity) 
    {
        call SingleActivityResourceLocal.set[id](newActivity);
    }

    inline async command void  
    SingleActivityResource.setLocal[uint8_t id](act_type_t newAct) 
    {
        call SingleActivityResourceLocal.setLocal[id](newAct);
    }

    inline async command void  
    SingleActivityResource.setUnknown[uint8_t id]() 
    {
        call SingleActivityResourceLocal.setUnknown[id]();
    }

    inline async command void  
    SingleActivityResource.setInvalid[uint8_t id]() 
    {
        call SingleActivityResourceLocal.setInvalid[id]();
    }

    inline async command void  
    SingleActivityResource.setIdle[uint8_t id]() 
    {
        call SingleActivityResourceLocal.setIdle[id]();
    }

    inline async command bool 
    SingleActivityResource.isValid[uint8_t id]() 
    {
        return call SingleActivityResourceLocal.isValid[id]();
    }

    inline async command void SingleActivityResource.bind[uint8_t id](act_t newActivity)
    {
        return call SingleActivityResourceLocal.bind[id](newActivity);
    }

    inline async command act_t SingleActivityResource.enterInterrupt[uint8_t id](act_t newActivity)
    {
        return call SingleActivityResourceLocal.enterInterrupt[id](newActivity);
    }

    inline async command void SingleActivityResource.exitInterrupt[uint8_t id](act_t restoreActivity)  
    {
        call SingleActivityResourceLocal.exitInterrupt[id](restoreActivity);
    }

    inline async command void SingleActivityResource.exitInterruptIdle[uint8_t id]()  
    {
        call SingleActivityResourceLocal.exitInterruptIdle[id]();
    }



    /* SingleActivityResourceTrack */

    inline async event void 
    SingleActivityResourceTrackLocal.changed[uint8_t id](act_t oldActivity, act_t newActivity) 
    {
        signal SingleActivityResourceTrack.changed[id](oldActivity, newActivity);
    }

    inline async event void 
    SingleActivityResourceTrackLocal.bound[uint8_t id](act_t oldActivity, act_t newActivity) 
    {
        signal SingleActivityResourceTrack.bound[id](oldActivity, newActivity);
    }

    inline async event void
    SingleActivityResourceTrackLocal.enteredInterrupt[uint8_t id](act_t oldActivity, act_t newActivity)
    {
        signal SingleActivityResourceTrack.enteredInterrupt[id](oldActivity, newActivity);
    }

    inline async event void
    SingleActivityResourceTrackLocal.exitedInterrupt[uint8_t id](act_t oldActivity, act_t newActivity)
    {
        signal SingleActivityResourceTrack.exitedInterrupt[id](oldActivity, newActivity);
    }

    //default implementations for unconnected parameters

    default async command act_t SingleActivityResourceLocal.get[uint8_t id]() {
        return ACT_INVALID;
    }

    default async command void SingleActivityResourceLocal.set[uint8_t id](act_t activity) {
    }

    default async command void SingleActivityResourceLocal.setLocal[uint8_t id](act_type_t newAct) {
    }

    default async command void SingleActivityResourceLocal.setUnknown[uint8_t id]() {
    }

    default async command void SingleActivityResourceLocal.setInvalid[uint8_t id]() {
    }

    default async command void SingleActivityResourceLocal.setIdle[uint8_t id]() {
    }

    default async command bool 
    SingleActivityResourceLocal.isValid[uint8_t id]() {
        return FALSE;
    }

    default async command void
    SingleActivityResourceLocal.bind[uint8_t id](act_t n) 
    {
    }

    default async command act_t 
    SingleActivityResourceLocal.enterInterrupt[uint8_t id](act_t newActivity) {
        return ACT_INVALID;
    }

    default async command void
    SingleActivityResourceLocal.exitInterrupt[uint8_t id](act_t restoreActivity) {
    }

    default async command void
    SingleActivityResourceLocal.exitInterruptIdle[uint8_t id]() {
    }

    /* SingleActivityResourceTrack */
    default async event void 
    SingleActivityResourceTrack.changed[uint8_t id](act_t oldActivity, act_t newActivity) {
    }

    default async event void 
    SingleActivityResourceTrack.bound[uint8_t id](act_t oldActivity, act_t newActivity) {
    }

    default async event void 
    SingleActivityResourceTrack.enteredInterrupt[uint8_t id](act_t oldActivity, act_t newActivity) {
    }

    default async event void 
    SingleActivityResourceTrack.exitedInterrupt[uint8_t id](act_t oldActivity, act_t newActivity) {
    }

}

