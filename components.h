#include <stdio.h>
#include <stdlib.h>

#define key 0xaaaa;//magic key

uint_32 output_memory(u_int16_t dataout, uint16 tag);

/* memory is a 16-bit component
*   0:      15 downto 0     secret key
*   1:      15 downto 0     output data
*   2:      15 downto 0      output key ##only 3 downto 0 will be used others are 0
*
*   total: 48 bits
*/

component ASSIGNMENT THING:
    port ( send              : in   std_logic,
           recv              : in   std_logic,
           network_in        : in   std_logic_vector(19 downto 0),
           cpu_in            : in   std_logic_vector(15 downto 0),
           attack            : out  std-logic,
           error             : out  std_logic,
           network_out       : out  std_logic_vector(29 downto 0),
           cpu_out           : out  std_logic_vector(15 downto 0));


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


ALU: 
    stuff


void input_reg(){
    /*
    input : {clk, reset, datain & tag(20bits), dataout & parity(17 bits)}

    output : {datain & tag(20bits), dataout & parity(17 bits)}
    */
}
/**
 * 
 * 
 */
/*
component data_memory is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(15 downto 0);
           addr_in      : in  std_logic_vector(3 downto 0);
           data_net     : out std_logic_vector(31 downto 0);
           data_out     : out std_logic_vector(15 downto 0) );
end component;
*/