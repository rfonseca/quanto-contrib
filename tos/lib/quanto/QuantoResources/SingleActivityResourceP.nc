configuration SingleActivityResourceP {
    provides {
        interface SingleActivityResource[uint8_t local_res_id];
        interface SingleActivityResourceTrack[uint8_t local_res_id];
        interface Init;
    }
}

implementation {
    components SingleActivityResourceImplP, ActivityTypeP;

    SingleActivityResource = SingleActivityResourceImplP;
    SingleActivityResourceTrack = SingleActivityResourceImplP;
    Init = SingleActivityResourceImplP;

    SingleActivityResourceImplP.ActivityType -> ActivityTypeP;
}
