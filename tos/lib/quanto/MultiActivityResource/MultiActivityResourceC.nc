#include "QuantoResources.h"
generic configuration MultiActivityResourceC(uint8_t global_res_id) {
    provides interface MultiActivityResource;
}
implementation {
    enum { LOCAL_ID = unique(QUANTO_MULTI_RESOURCE_UNIQUE) };
   
    components MultiActivityResourceG, MultiActivityResourceImplP;
    
    MultiActivityResource = MultiActivityResourceG.MultiActivityResource[global_res_id];
    
    MultiActivityResourceG.MultiActivityResourceLocal[global_res_id] -> 
                MultiActivityResourceImplP.MultiActivityResource[LOCAL_ID];
    MultiActivityResourceG.MultiActivityResourceTrackLocal[global_res_id] ->
                MultiActivityResourceImplP.MultiActivityResourceTrack[LOCAL_ID];
}
