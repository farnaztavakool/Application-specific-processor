---------------------------------------------------------------------------
-- instruction_memory.vhd - Implementation of A Single-Port, 16 x 16-bit
--                          Instruction Memory.
-- 
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(4 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end instruction_memory;

architecture behavioral of instruction_memory is

type mem_array is array(0 to 46) of std_logic_vector(15 downto 0);
signal sig_insn_mem : mem_array;

begin
    mem_process: process ( clk,
                           addr_in ) is
  
    variable var_insn_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        if (reset = '1') then
        
        
--            nop
--            load     rd, rt, addr     # rt can effectivly always be $0
--            store    rs, rt, addr     # rt can effectivly always be $0
--            parity   rd, rs, rt
--            bit_flip rd, rs, rt
--            rol      rd, rs, rt
--            xor      rd, rs, rt
--            bne      rs, rt, offset
--            set_sig  signals 3 bits
        
        
--                OPCODES: 4 bits
--                     binary  hex
--            nop      0000    0   
--            load     0001    1    
--            bne      0010    2
--            bit_flip 0100    4
--            rol      0101    5
--            xor      0110    6
--            parity   0111    7
--            set_sig  1000    8
--            store    1001    9


            
            
            
              -- main:
              var_insn_mem(0)  := X"1010";    -- load $1,$0,0

              -- while
         
              var_insn_mem(1)  := X"8000";    -- set_signal 0,0,"0000"
              
              --recv_done
              var_insn_mem(2)  := X"8000";    -- set_signal 0,0,"0000"
              var_insn_mem(3)  := X"2101";    -- bne $1,$0,1(while)
              var_insn_mem(4)  := X"0000";    -- nop
              
                --attack
              var_insn_mem(5)  := X"800C";    -- set_signal 0,0,"1200"
              var_insn_mem(6)  := X"2101";    -- bne $1,$0,1 (while)
              var_insn_mem(7)  := X"0000";    -- nop
              
              -- error
              var_insn_mem(8)  := X"800A";    -- set_signal 0,0,"1010"
              var_insn_mem(9)  := X"2522";    -- bne $1,$0,2 (while)
              var_insn_mem(10)  := X"0000";    -- nop 
              
              --do_recieve
              var_insn_mem(11)  := X"8008";    -- set_signal 0,0,"1000"
              var_insn_mem(12)  := X"0000";    -- nop
              var_insn_mem(13)  := X"4215";    -- bit_flip $5,$2,$1
              var_insn_mem(14)  := X"0000";    -- nop
              var_insn_mem(15)  := X"0000";    -- nop
              var_insn_mem(16)  := X"5516";    -- rol $6,$5,$1
              var_insn_mem(17)  := X"0000";    -- nop
              var_insn_mem(18)  := X"0000";    -- nop              
              var_insn_mem(19)  := X"6607";    -- xor $7,$6,$0
              var_insn_mem(20)  := X"0000";    -- nop
              var_insn_mem(21)  := X"0000";    -- nop 
              var_insn_mem(22)  := X"2745";    -- bne $7,$4,attack           
              var_insn_mem(23)  := X"0000";    -- nop
              var_insn_mem(24)  := X"8009";    -- set_signal $0,$0,"1001"
              var_insn_mem(25)  := X"2102";    -- bne $1,$0,2 (recv_done)
              var_insn_mem(26)  := X"0000";    -- nop
              
            
            
              --do_send  
              var_insn_mem(27)  := X"8008";    -- set_signal 0,0,"1000"
              var_insn_mem(28)  := X"0000";    -- nop
              var_insn_mem(29)  := X"7235";    -- parity $5,$2,$3
              var_insn_mem(30)  := X"0000";    -- nop
              var_insn_mem(31)  := X"0000";    -- nop
              var_insn_mem(32)  := X"252A";    -- bne $1,$0,10 (error)
              var_insn_mem(33)  := X"0000";    -- nop
              var_insn_mem(34)  := X"4215";    -- bit_flip $5,$2,$1
              var_insn_mem(35)  := X"0000";    -- nop
              var_insn_mem(36)  := X"0000";    -- nop
              var_insn_mem(37)  := X"5516";    -- rol $6,$5,$1
              var_insn_mem(38)  := X"0000";    -- nop
              var_insn_mem(39)  := X"0000";    -- nop              
              var_insn_mem(40)  := X"6607";    -- xor $7,$6,$0
              var_insn_mem(41)  := X"0000";    -- nop
              var_insn_mem(42)  := X"0000";    -- nop               
              var_insn_mem(43)  := X"9021";    -- store $2,$0,1
              var_insn_mem(44)  := X"9072";    -- store $7,$0,1
              var_insn_mem(45)  := X"2522";    -- bne $1,$0,2 (while)
              var_insn_mem(46)  := X"0000";    -- nop               

             
        elsif (falling_edge(clk)) then
            -- read instructions on the rising clock edge
            var_addr := conv_integer(addr_in);
            insn_out <= var_insn_mem(var_addr);
        end if;

        -- the following are probe signals (for simulation purpose)
        sig_insn_mem <= var_insn_mem;

    end process;
  
end behavioral;
