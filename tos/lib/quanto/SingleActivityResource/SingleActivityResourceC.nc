generic configuration SingleActivityResourceC(uint8_t res_id) {
	provides interface SingleActivityResource;
}
implementation {
	components SingleActivityResourceP;
	SingleActivityResource = SingleActivityResourceP[res_id];
}
