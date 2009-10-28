generic module A() {
   provides command uint8_t getId();
}
implementation {
   enum { LOCAL_ID = unique("activities_map") };
   command uint8_t getId() {
      return LOCAL_ID;
   }
}
