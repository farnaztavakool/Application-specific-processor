/*
        ISA:    draft 
    load    
    store    
    parity   rd, rs
    bit_flip rd, rs, rt
    rol      rd, rs, rt
    xor      rd, rs, rt
    beq      rs, rt, offset
    
    R-type |opcode|rs|rt|rd| #instruction memory may not suffcient for 16 bits

        #tag_gen key is in rt
        #data be gen is in rs
        #store gen to rd

    
    tag_gen01  rd, rs, rt #tag for d0 d1
    tag_gen23  rd, rs, rt #tag for d2 d3

                # tag_gen could be devide into flip and ROL 
                # pros: shorter path length 
                # cons: one extra clock cycle, opcode size limit

            filp rd, rs, rt #flip rs by rt and store into rd

            ROL  rd, rs, rt #ROL  rs by rt and store into rd

    XOR     rd, rs, rt #XOR rs(15-8)rs(7-0),rt(15-8)rt(7-0) and save to memory out
    parity   rd,rs,rt   #check the rs&rt with rd(0)

        #may not needed if using parrell register file
    savein   rd,rs,rt   #save datain to ($rs, $rt) and tag to $rd
    saveout  rd,rs,rt   #save dataout to ($rs, $rt) and parity to $rd 
                        #and save the data to output memory unit
    
    

*/
