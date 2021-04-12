/*
        ISA:    draft 

        32-BIT ARCHITECTURE

        INSTRUCTIONS
    nop
    load     rd, rt, offset     # rt can effectivly always be $0
    store    rs, rt, offset     # rt can effectivly always be $0
    parity   rd, rs, rt
    bit_flip rd, rs, rt
    rol      rd, rs, rt
    xor      rd, rs, rt
    bne      rs, rt, offset
    j        offset


        OPCODES: 4 bits
             binary  hex
    nop      0000    0   
    load     0001    1    
    store    0010    2
    parity   0011    3
    bit_flip 0100    4
    rol      0101    5
    xor      0110    6
    bne      0111    7
    j        1000    8
    
    
        FORMATS: 
    R-type | opcode(31-28) | rs(27-24) | rt(23-20) | rd(19-16) | empty(15-0) |

        filp    rd, rs, rt      # flip rs in chunks of 4-bits by rt and store into rd

        ROL     rd, rs, rt      # ROL  rs by rt and store into rd

        XOR     rd, rs, rt      # XOR rs(15-8)rs(7-0),rt(15-8)rt(7-0) and save rd

        parity  rd, rs, rt      # find the parity of rs, check this result with
                                # lowest bit of rt, store result in rd


    I-type | opcode(31-28) | rs(27-24) | rt(23-20) | rd(19-16) | empty (15-0) |    
    
        load    rd, rt, offset  # load from rt + offset into rd

        store   rs, rt, offset  # store rs into rt + offset

        bne     rs, rt, offset  # if rs != rt branch to PC + offset


    J-Type | opcode(31-28) | address(27-0) |

        j   offset              # unconditional jump to PC + offset
    

*/
