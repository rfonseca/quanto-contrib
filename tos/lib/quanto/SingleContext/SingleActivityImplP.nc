#include "activity.h"

/* Provides a parameterized set of single Activity interfaces 
   The parameterization is on local resource ids, made from
   unique(QUANTO_SINGLE_RESOURCE_UNIQUE) */

module SingleActivityResourceImplP {
    provides {
        interface SingleActivityResource[uint8_t res_id];
        interface SingleActivityResourceTrack[uint8_t res_id];
        interface Init;
    }
    uses {
        interface ActivityType;
    }
}

implementation {
    enum { NUM_RES = uniqueCount(QUANTO_SINGLE_RESOURCE_UNIQUE) }; 
    act_t m_activity[NUM_RES]; 
    act_t act_local_unknown;
    act_t act_local_idle;
    act_t act_local;

    /* Set the activity of all resources to unknown activity and
     * this node's id */
    command error_t Init.init() {
        int i;

        act_local_unknown = mk_act_local(QUANTO_ACTIVITY(UNKNOWN));
        act_local_idle = mk_act_local(QUANTO_ACTIVITY(IDLE));
        act_local = mk_act_local(0); //this is here so that changes in IDLE don't cause bugs

        for (i = 0; i < NUM_RES; i++) {
            m_activity[i] = act_local_idle;
        }
        return SUCCESS;
    }

    async inline command act_t SingleActivityResource.get[uint8_t res_id]() {
        atomic return m_activity[res_id];
    }

    async inline command void SingleActivityResource.set[uint8_t res_id](act_t n) {
        act_t old;
        atomic {
                old = m_activity[res_id];
                m_activity[res_id] = n;
        } 
        if (n != old)
            signal SingleActivityResourceTrack.changed[res_id](n);
    }

    async inline command void SingleActivityResource.setLocal[uint8_t res_id](act_type_t a) {
        call SingleActivityResource.set[res_id](mk_act_local(a));
    }

    async inline command void 
    SingleActivityResource.bind[uint8_t res_id](act_t n) {
        act_t old;
        atomic {
                old = m_activity[res_id];
                m_activity[res_id] = n;
        } 
        if (n != old)
            signal SingleActivityResourceTrack.bound[res_id](n);
    }


    async inline command act_t 
    SingleActivityResource.enterInterrupt[uint8_t res_id](act_t n) 
    {
        act_t old;
        n = act_local | (n & ACT_TYPE_MASK);
        atomic {
            old = m_activity[res_id];
            m_activity[res_id] = n;
        }
        signal SingleActivityResourceTrack.enteredInterrupt[res_id](n);
        return old;
    }

    async inline command void 
    SingleActivityResource.exitInterrupt[uint8_t res_id](act_t restore_ctx) 
    {
        act_t old;
        if (restore_ctx == act_local_idle)
            return;
        atomic {
            old = m_activity[res_id];
            m_activity[res_id] = restore_ctx;
        }
        signal SingleActivityResourceTrack.exitedInterrupt[res_id](restore_ctx);   
    }

    async inline command void 
    SingleActivityResource.exitInterruptIdle[uint8_t res_id]() 
    {
        act_t old;
        atomic {
            old = m_activity[res_id];
            m_activity[res_id] = act_local_idle;
        }
        signal SingleActivityResourceTrack.exitedInterrupt[res_id](act_local_idle);   
    }


    
    async inline command void  
    SingleActivityResource.setUnknown[uint8_t res_id]() 
    {
        call SingleActivityResource.set[res_id](act_local_unknown);
    }

    async inline command void  
    SingleActivityResource.setIdle[uint8_t res_id]() 
    {
        call SingleActivityResource.set[res_id](act_local_idle);
    }
    
    async inline command void  
    SingleActivityResource.setInvalid[uint8_t res_id]() 
    {
        call SingleActivityResource.set[res_id](ACT_INVALID);
    }

    async inline command bool  
    SingleActivityResource.isValid[uint8_t res_id]()
    {
        return call ActivityType.isValid(&m_activity[res_id]);
    }

    default async event void 
    SingleActivityResourceTrack.changed[uint8_t res_id](act_t oldAct, act_t newAct)
    {
    }

    default async event void
    SingleActivityResourceTrack.bound[uint8_t res_id](act_t oldAct, act_t newAct) {
    }

    default async event void 
    SingleActivityResourceTrack.enteredInterrupt[uint8_t res_id](act_t oldAct, act_t newAct) {
    }

    default async event void 
    SingleActivityResourceTrack.exitedInterrupt[uint8_t res_id](act_t oldAct, act_t newAct) {
    }
    

}
