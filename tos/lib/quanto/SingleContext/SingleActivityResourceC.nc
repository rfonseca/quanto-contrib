#include "QuantoResources.h"
generic configuration SingleResourceActivityC(uint8_t global_res_id) {
    provides interface SingleResourceActivity;
}
implementation {
   enum { LOCAL_ID = unique(QUANTO_SINGLE_RESOURCE_UNIQUE) };

   components SingleResourceActivityG, SingleResourceActivityP; 

   SingleResourceActivity = SingleResourceActivityG.SingleResourceActivity[global_res_id];

   SingleResourceActivityG.SingleResourceActivityLocal[global_res_id] -> 
                  SingleResourceActivityP.SingleResourceActivity[LOCAL_ID];
   SingleResourceActivityG.SingleResourceActivityTrackLocal[global_res_id] -> 
                  SingleResourceActivityP.SingleResourceActivityTrack[LOCAL_ID];
}
