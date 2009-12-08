#include "QuantoResources.h"
generic configuration SingleActivityResourceC(uint8_t global_res_id) {
    provides interface SingleActivityResource;
}
implementation {
   enum { LOCAL_ID = unique(QUANTO_SINGLE_RESOURCE_UNIQUE) };

   components SingleActivityResourceG, SingleActivityResourceP; 

   SingleActivityResource = SingleActivityResourceG.SingleActivityResource[global_res_id];

   SingleActivityResourceG.SingleActivityResourceLocal[global_res_id] -> 
                  SingleActivityResourceP.SingleActivityResource[LOCAL_ID];
   SingleActivityResourceG.SingleActivityResourceTrackLocal[global_res_id] -> 
                  SingleActivityResourceP.SingleActivityResourceTrack[LOCAL_ID];
}
