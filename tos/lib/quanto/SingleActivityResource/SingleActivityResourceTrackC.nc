configuration SingleActivityResourceTrackC {
    provides interface SingleActivityResourceTrack[uint8_t id];
}
implementation {
    components SingleActivityResourceP;
    SingleActivityResourceTrack = SingleActivityResourceP;
}
