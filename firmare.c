#include <stdio.h>
#include <stdlib.h>



/*
        ISA:    draft 
    load    
    store    
    parity   rd, rs
    bit_flip rd, rs, rt
    rol      rd, rs, rt
    xor      rd, rs, rt
    beq      rs, rt, offset

*/


int main(void) {

    // poll 
    while(1) {

        int recieve;
        int send;

        // recieve flag for valid incomming data    <- from network
        // send flag for valid outgoing data        -> network

        /*  TODO
            REGISTER MEMORY
            {    in_data_network
            {    valid_recieve
        
            DATA MEMORY
                key                 8 bits
            {    in_data_processor   32 bits
            {    parity_bit          1 bit
            {    valid_in_data       1 bit
            |    data_to_network     32 bit
            |    tag_to_network      8 bits
                attack_sig          1 bit
                error_sig           1 bit

        */

       // read in data 
       // perform firmware -> no handshake, just drop packets
       // read in next data

        if (recieve == 1) {
            do_recieve();
            //rec_handshake();
        } 
        if (send == 1) {
            do_send();
            //send_handshake();
        }
    }
}


/* recieve data from network -> send to processor */
// Read from registers
// data sent to registers from .txt by test bench
void do_recieve(uint_32 data, uint_8 tag_original) {
    // data from network
    uint_8 tag_generated = tag_gen(data);

    if (tag_generated != tag_original) {
        // drop data
        data = 0;
        attack_sig = 1;
    }

    // else data valid
    // set valid signal to recieving processor
    valid_to_processor = 1;

    // TODO where to put the data to processor
}


/* send data to network <- recieve from processor */
// TODO read from???
void do_send(uint_32 data, uint_1 parity_in) {

    // calc paritiy bit
    uint_1 parity = parity_cal(data);  // insn

    if (parity_in != parity) {
        // drop data
        data = 0;
        error_sig = 1;
    }

    uint_8 = tag = tag_gen(data, key);

    valid_to_network = 1;
    return data & tag;  // 40 bits -> network : put in data

}

uint_8 tag_gen(uint_32 data, uint_16 key) {
    // many instructions
    // split into 4 8 bit chunks
    // data_bef_x is register
    data_bf_upper = bit_flip_insn(data(15 downto 8), key(15 downto 12));   // insn
    data_bf_lower = bit_flip_insn(data(7 downto 0), key(15 downto 12));    // insn

    // justify having rol as a 16 bit instruction, which splits into two 8 bit chunks
    // split the secret key into two 3 bit chunks
    // performs two simultaneous rols
    // concationates data again
    data_rol_upper = rol_insn(data_bf_upper, key(11 downto 6));     // insn
    data_rol_lower = rol_insn(data_bf_lower, key(5 downto 0));      // insn

    tag = xor(data_rol_upper, data_rol_lower);                      // insn

    return tag;
}