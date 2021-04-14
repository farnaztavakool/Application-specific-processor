/*

    ######## OPCODES ########
    nop      0000    0   
    load     0001    1    
    store    0010    2
    parity   0011    3
    bit_flip 0100    4
    rol      0101    5
    xor      0110    6
    bne      0111    7
    set_sig  1000    8



    ######## GENERAL CONTROL SIGNALS ########
    load_status <= '1' when opcode = OP_SET_SIG else
                   '0';

    -- input to processor from test bench
    send        <= '1' when doing send else 
                   '0';

    -- input to processor from test bench
    recv        <= '1' when doing recieve else 
                   '0';


    ######## I/O UNIT SIGNALS ########
    -- controls many signals throughout CPU
    status_register : busy | attack | error | valid

    -- controls writing into the special hardcoded registers: 
    -- $2 = data_in, $3 = parity_in, $4 = tag_in
    write_enable_special <= '1' when busy = '0' else 
                            '0'


    ######## FROM PIPELINE PROCESSOR ########
    -- asserted for ADD instructions, so that the register
    -- destination number for the 'write_register' comes from
    -- the rd field (bits 3-0). 
    reg_dst    <= '1' when (opcode = OP_ADD
                            or opcode = OP_SLL) else
                  '0';

    -- asserted for ADD and LOAD instructions, so that the
    -- register on the 'write_register' input is written with
    -- the value on the 'write_data' port.
    reg_write  <= '1' when (opcode = OP_ADD 
                            or opcode = OP_LOAD
                            or opcode = OP_SLLI
                            or opcode = OP_SLL) else
                  '0';
      
    --     mem_write  : asserted for STORE instructions, so that the data 
    --                  memory contents designated by the address input are
    --                  replaced by the value on the 'write_data' input.         
    mem_write  <= '1' when opcode = OP_STORE else
                  '0';

    --     mem_to_reg : asserted for LOAD instructions, so that the value fed
    --                  to the register 'write_data' input comes from the
    --                  data memory.            
    mem_to_reg <= '1' when opcode = OP_LOAD else
                  '0';

    --    branch      : asserted in the case of a branch instruction, used in
    --                  in branching logic            
    branch     <= '1' when opcode = OP_BNE else 
                  '0';



    ######## ALU CONTROL SIGNALS ########

        -- determines which input comes into the alu as source B
        -- TODO NEED DATA PATH
        alu_src    <= '1' when (opcode = OP_LOAD 
                           or opcode = OP_STORE
                           or opcode = OP_SLLI) else
                  '0';
        
        -- determine which output comes out as output from the alu
        -- 2 bits wide
            parity  
            bit_flip 
            rol      
            xor      
        alu_str    <=   '00'  when opcode = parity
                        '01'  when opcode = bit_flip
                        '10'  when opcode = rol
                        '11'  when opcode = xor;

*/ 