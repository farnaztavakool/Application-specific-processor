/*
        ISA:    draft 

        16-BIT ARCHITECTURE

        INSTRUCTIONS
    nop
    load     rd, rt, offset     # rt can effectivly always be $0
    store    rs, rt, offset     # rt can effectivly always be $0
    parity   rd, rs, rt
    bit_flip rd, rs, rt
    rol      rd, rs, rt
    xor      rd, rs, rt
    bne      rs, rt, offset
    set_sig  signals 3 bits


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
    set_sig  1000    8
    
    
        FORMATS:  |
    R-type | opcode(15-12) | rs(11-8) | rt(7-4) | rd(3-0) |

        filp    rd, rs, rt      # flip rs in chunks of 4-bits by rt and store into rd

        ROL     rd, rs, rt      # ROL  rs by rt and store into rd

        XOR     rd, rs, rt      # XOR rs(15-8)rs(7-0),rt(15-8)rt(7-0) and save rd

        parity  rd, rs, rt      # find the parity of rs, check this result with
                                # lowest bit of rt, store result in rd


    I-type | opcode(15-12) | rs(11-8) | rd(7-4) | imm(3-0) |

        load    rd, rt, offset          # load from rt + offset into rd

        store   rs, rt, offset          # store rs into rt + offset

        bne     rs, rt, offset          # if rs != rt branch to PC + offset

        set_sig 0,  0,  signal          # put signal into pre-defined status register


    J-type | opcode(15-12) | absolute address(11 downto 0) | 

        check_recv address              # does a jump to address if recv signal is high

        check_send address              # does a jump to address if send signal is high

*/
