/* Set of integers from 0..size */
generic module IntegerSetC(uint8_t SIZE) {
   provides interface IntegerSet;
}
implementation {
    uint8_t set[SIZE/8 + 1];
    uint8_t elements = 0;

    command uint8_t IntegerSet.capacity()
    {
      return SIZE;
    }

    /* Make set empty */
    command void IntegerSet.clear()
    {
      memset(&set, 0, sizeof(set));
      elements = 0; 
    }

    /* Idempotent add */
    command void IntegerSet.add(uint8_t element)
    {
      uint8_t byte = element / 8;
      uint8_t mask = 1 << (element - (byte * 8));
      if (element > SIZE)
         return; 
      if (!(set[byte] & mask)) {
         set[byte] |= mask;
         elements++;
      }
    }
    /* Idempotent remove */
    command void IntegerSet.remove(uint8_t element) 
    {
      uint8_t byte = element / 8;
      uint8_t mask = 1 << (element - (byte * 8));
      if (element > SIZE)
         return; 
      if (set[byte] & mask) {
         set[byte] &= ~mask;
         elements--;
      }
    }

    /* Whether element is a member */
    command uint8_t IntegerSet.isMember(uint8_t element)
    {
      uint8_t byte = element / 8;
      uint8_t mask = 1 << (element - (byte * 8));
      if (element > SIZE)
         return 0;
      return (set[byte] & mask)?1:0;
    }
    /* Number of elements */
    command uint8_t IntegerSet.numElements() {
      return elements; 
    }
    //uint8_t IntegerSet.largestElement();
}

