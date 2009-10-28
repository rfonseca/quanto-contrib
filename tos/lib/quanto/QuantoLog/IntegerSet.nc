interface IntegerSet {
    /* Make set empty */
    command void clear();
    /* Idempotent add */
    command void add(uint8_t element);
    /* Idempotent remove */
    command void remove(uint8_t element);
    /* Whether element is a member */
    command uint8_t isMember(uint8_t element);
    /* Number of elements */
    command uint8_t numElements();
    /* Maximum number of elements */
    command uint8_t capacity();
    //uint8_t largestElement();
}

