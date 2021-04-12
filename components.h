#include <stdio.h>
#include <stdlib.h>

#define key 0xaaaa;//magic key

uint_40 output_memory(u_int16_t dataout, uint8 tag);

/* memory is a 64 bit component
*   // TODO figure out how to interact, 32 or 16 bits
*   // TODO work out offsets
*
*  - secret key
*  - output data 
*  - output key
*/


void input_reg(){
    /*
    input : {clk, reset, datain & tag(20bits), dataout & parity(17 bits)}

    output : {datain & tag(20bits), dataout & parity(17 bits)}
    */
}