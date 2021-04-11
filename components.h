#include <stdio.h>
#include <stdlib.h>

#define key 0xa;//magic key

uint_40 output_memory(u_int16_t dataout, uint8 tag);

void input_reg(){
    /*
    input : {clk, reset, datain & tag(20bits), dataout & parity(17 bits)}

    output : {datain & tag(20bits), dataout & parity(17 bits)}
    */
}