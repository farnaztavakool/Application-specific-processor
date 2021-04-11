
    .data
key:
    .word 0xa
    

    .text
mian:
    la		$t1, key		# 
    lw		$s0, 0($t1)		# 
    
while:
    #clear signals/ set status reg
    valid <= 0;
    attack <= 0;

    # current set up is 0 for signal true
    bne		recv, $0, do_receive 	# if recv == 1 then do_receive
    bne		send, $0, do_send	# if send == 1 then do_send
    j		while				# jump to while
    
    

do_receive:
    savein $rd, $rs, $rt 

    #checking tag
    tag_gin01 $rd, $rs, $rt
    tag_gin23 $rd, $rs, $rt
    XOR     $rd, $rs, $rt
    bne		$ts, $rt, attack	# if tag !=tag then attack situation
    valid <= 1;
    j		while				# jump to while
    
attack:
    attack <= 1;
    j		while				# jump to while
    
do_send:
    saveout $rd, $rs, $rt
    
    #checking parity
    parity $rd,$rs,$rt  #parity data $a1,$a2 with parity bit $a3 from input_reg
    
    bne		$rs, $rt, error	# if parity error
    #gentag
    tag_gin01 $rd, $rs, $rt
    tag_gin23 $rd, $rs, $rt
    XOR $rd, $rs, $rt
    
    save_out_mem $rd, $rs,$rt #save data rs, rt, and tag rd to output_mem
    j		while				# jump to while
    
error:
    soft_error <= '1';
    j		while				# jump to while
    
