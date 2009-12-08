configuration MultiActivityResourceTrackC {
    provides interface MultiActivityResourceTrack[uint8_t id];
}
implementation {
    components MultiActivityResourceG;
    MultiActivityResourceTrack = MultiActivityResourceG;
}
