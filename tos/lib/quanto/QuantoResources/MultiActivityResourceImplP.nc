#include "activity.h"
#include "QuantoResources.h"

/* Proxy implementation. This module does not keep internal state
 * about the actual membership. All it does is relay the added and
 * removed states to the tracker module. */

module MultiActivityResourceImplP {
    provides {
        interface MultiActivityResource[uint8_t res_id];
        interface MultiActivityResourceTrack[uint8_t res_id];
        interface Init;
    }
}
implementation {
    enum { NUM_RES = uniqueCount(QUANTO_MULTI_RESOURCE_UNIQUE) };

    command error_t Init.init() {
        int i;
        for ( i = 0; i < NUM_RES; i++) {
            signal MultiActivityResourceTrack.idle[i]();
        }       
        return SUCCESS;
    } 
   

    async command error_t
    MultiActivityResource.add[uint8_t res_id](act_t activity)
    {
        signal MultiActivityResourceTrack.added[res_id](activity);
        return SUCCESS;
    }

    async command error_t
    MultiActivityResource.remove[uint8_t res_id](act_t activity)
    {
        signal MultiActivityResourceTrack.removed[res_id](activity);
        return SUCCESS;
    }
    
    async command error_t
    MultiActivityResource.setIdle[uint8_t res_id]()
    {
        signal MultiActivityResourceTrack.idle[res_id]();
        return SUCCESS;
    }

    default async event void
    MultiActivityResourceTrack.added[uint8_t res_id](act_t activity) {
    }

    default async event void
    MultiActivityResourceTrack.removed[uint8_t res_id](act_t activity) {
    }

    default async event void
    MultiActivityResourceTrack.idle[uint8_t res_id]() {
    }

}
