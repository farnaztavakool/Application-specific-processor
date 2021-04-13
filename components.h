#include <stdio.h>
#include <stdlib.h>

#define key 0xaaaa;//magic key

uint_40 output_memory(u_int16_t dataout, uint8 tag);

/* memory is a 32-bit component
*   0:      15 downto 0     secret key
*   1:      31 downto 0     output data
*   2:      7 downto 0      output key
*
*   total: 96 bits
*/


void input_reg(){
    /*
    input : {clk, reset, datain & tag(20bits), dataout & parity(17 bits)}

    output : {datain & tag(20bits), dataout & parity(17 bits)}
    */
}