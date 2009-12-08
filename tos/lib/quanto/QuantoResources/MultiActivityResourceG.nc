/* mapping between global and local id spaces */
/* see MultiActivityResourceC for wiring */

module MultiActivityResourceG {
    provides interface MultiActivityResource[uint8_t id];
    provides interface MultiActivityResourceTrack[uint8_t id];
    uses interface MultiActivityResource as MultiActivityResourceLocal[uint8_t id];
    uses interface MultiActivityResourceTrack as MultiActivityResourceTrackLocal[uint8_t id];
}
implementation {
    async command error_t
    MultiActivityResource.add[uint8_t id](act_t activity)
    {
        return call MultiActivityResourceLocal.add[id](activity);
    }

    async command error_t
    MultiActivityResource.remove[uint8_t id](act_t activity)
    {
        return call MultiActivityResourceLocal.remove[id](activity);
    }

    async command error_t
    MultiActivityResource.setIdle[uint8_t id]()
    {
        return call MultiActivityResourceLocal.setIdle[id]();
    }
    
    async event void
    MultiActivityResourceTrackLocal.added[uint8_t id](act_t activity)
    {
        signal MultiActivityResourceTrack.added[id](activity);
    }
    
    async event void
    MultiActivityResourceTrackLocal.removed[uint8_t id](act_t activity)
    {
        signal MultiActivityResourceTrack.removed[id](activity);
    }

    async event void
    MultiActivityResourceTrackLocal.idle[uint8_t id]()
    {
        signal MultiActivityResourceTrack.idle[id]();
    }
    
    /* Default impl for unconnected parameters */
    default async command error_t  
    MultiActivityResourceLocal.add[uint8_t id](act_t activity) {
       return FAIL; 
    }

    default async command error_t
    MultiActivityResourceLocal.remove[uint8_t id](act_t activity) {
        return FAIL;
    }

    default async command error_t
    MultiActivityResourceLocal.setIdle[uint8_t id]() {
        return FAIL;
    }

    default async event void
    MultiActivityResourceTrack.added[uint8_t id](act_t activity) {
    }
        
    default async event void
    MultiActivityResourceTrack.removed[uint8_t id](act_t activity) {
    }
        
    default async event void
    MultiActivityResourceTrack.idle[uint8_t id]() {
    }
}
