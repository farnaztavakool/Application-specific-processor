#   current firmware>
#   this version assumes 5-stage pipelined processor
#

    .data
key:    # the address of key is hardset and known, in memory it'll be at 0                
    .word 0xAAAA    # 1010  101 010 101 010
                    # 15    11  8   5   2 0
 

    .text
main:
    load	$1, $0, 0		    # key is at offset 0+0
    
while:
    # clear signals/ set status reg
    # busy <=0;
    # valid <= 0;
    # attack <= 0;
    # error <= 0;

    # signal register: busy | attack | error | valid
    set_sig 0000       # set three bit ctr sig to 0000

    # go to do_recieve
    # handled by hardware:
    # if recv && not busy <- PC = do_recieve

recv_done:
    # reset busy
    set_sig 0000

    # go to do_send
    # handled by hardware:
    # if send && not busy <- PC = do_send

    # unconditional jump to while
    bne     $1, $0, while       # $0 = 0, $1 = AAAA
    nop
    

do_receive:
    # the test bench can theoretically pipe data into regs
    # if not we need an instruction for loading from network

    set_sig 1000    # set busy, WE ARE BUSY PROCESSING IGNORE NEW DATA
    nop             # to allow $2, $3, $4 to load by hardware

    # recieve signal high : data loaded
    # $2 contains input data, 32-bits
    # $3 reserved for parity
    # $4 contains input tag

    #checking tag
    bit_flip $5, $2, $1         # bit flip data ($2) by key ($1)

    # rol insn has id stage during previous insn's wb
    # ensure the processor writes on a rising edge, and reads on a falling
    rol      $6, $5, $1         # rol fliped data ($5) by key ($1)

    XOR      $7, $6, $0         # xor the bits of tag, this is an 8 bit result
    nop 
    nop

    bne		 $7, $4, attack	    # if tag($7) != tag($4) then attack situation
    nop                         # control stall if branch is true
    
    
    
    bne     $1, $0, recv_done    # $0 = 0, $1 = AAAA
    # valid <= 1; branch delay slot
    set_sig 1001                # set three bit ctr sig to 001
    
attack:
    # attack <= 1;
    set_sig 1100
    bne     $1, $0, recv_done       # jump to recv_done    
    nop
    
do_send:

    set_sig 1000    # set busy, WE ARE BUSY PROCESSING IGNORE NEW DATA
    nop             # to allow $2, $3, $4 to load
    # or some kind of load instruction

    # $2 contains input data, 32-bits
    # $3 contains parity
    # $4 reserved for input tag
    
    #checking parity
    parity $5, $2, $3       # check parity of input data ($2) with input parity bit ($3), 
    nop                     # put result in rd ($5)
    nop
    bne	   $5, $2, error	# if parity error
    nop

    # generating tag
    bit_flip $5, $2, $1         # bit flip data ($2) by key ($1)

    # rol insn has id stage during previous insn's wb
    # ensure the processor writes on a rising edge, and reads on a falling
    rol      $6, $5, $1         # rol fliped data ($5) by key ($1)

    XOR      $7, $6, $0         # xor the bits of tag, this is an 8 bit result
    nop 

    # write data
    store $2, $0, (out_location_data)   # store data at 0 + out_location_data
    store $7, $0, (out_location_tag)    # store generated tag at 0 + out_location_tag

                				# jump to while
    bne     $1, $0, while       # $0 = 0, $1 = AAAA
    
error:
    # soft_error <= '1';
    set_sig 1010    		
    bne     $1, $0, while       # jump to while
    nop
