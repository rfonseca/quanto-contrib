
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#define MIG
#include "../../activity.h"

enum {ACTS = 15};

uint16_t hash_1(act_t a) {
   return a;
}
int main() {
   uint8_t acts[ACTS] = {0,1,2,3,5,10,11,12,20,21,22,54,55,56,62};
   uint16_t n,i;
   uint8_t col[65536];
   uint16_t h;
   int collisions = 0;
   memset(col, 0, sizeof(collisions));
   for (n = 0; n < 40; n++) {
      for (i = 0; i < ACTS; i++) {
         act_t a = ((n & ACT_NODE_MASK) << ACT_NODE_OFF | (acts[i] & ACT_TYPE_MASK));
         h = hash_1(a); 
         if (col[h]++) {
            collisions++;
         }
         printf("hash_1(%d = %d.%d) = %d collisions = %d\n", a, n, acts[i], h, collisions);
      }
   }
}
