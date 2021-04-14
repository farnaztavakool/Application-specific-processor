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


component ASSIGNMENT THING:
    port ( send              : in   std_logic,
           recv              : in   std_logic,
           network_in        : in   std_logic_vector(39 downto 0),
           cpu_in            : in   std_logic_vector(32 downto 0),
           attack            : out  std-logic,
           error             : out  std_logic,
           network_out       : out  std_logic_vector(39 downto 0),
           cpu_out           : out  std_logic_vector(32 downto 0));


status_register: 
    set_status_in : std_logic_vector(2 downto 0),
    enable        : std_logic,
    status_out    : std_logic_vector(2 downto 0);


I/O_UNIT
    DONG WRITE pls 


##### ALU #####
parity:
    

rol: 


bit_flip:


xor:


void input_reg(){
    /*
    input : {clk, reset, datain & tag(20bits), dataout & parity(17 bits)}

    output : {datain & tag(20bits), dataout & parity(17 bits)}
    */
}