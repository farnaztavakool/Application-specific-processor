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
           addr_in  : in  std_logic_vector(3 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end instruction_memory;

architecture behavioral of instruction_memory is

type mem_array is array(0 to 15) of std_logic_vector(15 downto 0);
signal sig_insn_mem : mem_array;

begin
    mem_process: process ( clk,
                           addr_in ) is
  
    variable var_insn_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        if (reset = '1') then
            -- OPCODES
            --  nop         = 0 : 0000
            --  load        = 1 : 0001
            --  store       = 3 : 0011
            --  add         = 8 : 1000
            --  shift left  = 5 : 0101
            --  bne         = 2 : 0010
            --  shift left immediate = 4 = 0100
            
            -- FOMATS
            --  isns rd, rs, rt/imm
            --  R-type opcode | rs | rt | rd
            --  I-type opcode | rs | rd | imm
            
            -- bne jumps -> pc + offset + 1
            
            var_insn_mem(0)  := X"101C";    -- load  $1, $0, C
            var_insn_mem(1)  := X"102D";    -- load  $2, $0, D
            var_insn_mem(2)  := X"103E";    -- load  $3, $0, E
            var_insn_mem(3)  := X"104F";    -- load  $4, $0, F

            var_insn_mem(4)  := X"8121";    -- add $1, $1, $2
            var_insn_mem(5)  := X"5131";    -- sll $1, $1, $3
            var_insn_mem(6)  := X"3032";    -- store $3, $0, 2
            
            var_insn_mem(7)  := X"1052";    -- load  $5, $0, 2
            var_insn_mem(8)  := X"2112";    -- bne   $1, $1, 2
            var_insn_mem(9)  := X"2212";    -- bne   $1, $2, 2
            var_insn_mem(10) := X"0000";
            var_insn_mem(11) := X"0000";
            var_insn_mem(12) := X"3018";    -- store $1, $0, 8
            var_insn_mem(13) := X"0000";
            var_insn_mem(14) := X"0000";
            var_insn_mem(15) := X"0000";
            
            -- other instructions for another test case
            --var_insn_mem(0)  := X"101C";    -- load  $1, $0, C
            --var_insn_mem(1)  := X"102D";    -- load  $2, $0, D
            --var_insn_mem(2)  := X"103E";    -- load  $3, $0, E
            --var_insn_mem(3)  := X"104F";    -- load  $4, $0, F

            --var_insn_mem(4)  := X"8121";    -- add $1, $1, $2
            --var_insn_mem(5)  := X"8131";    -- add $1, $1, $3
            --var_insn_mem(6)  := X"5131";    -- sll $1, $1, $3
            --var_insn_mem(7)  := X"3132";    -- store $3, $1, 2
            --var_insn_mem(8)  := X"3013";    -- store $1, $0, 3
            
            --var_insn_mem(10) := X"2112";    -- bne   $1, $1, 2
            --var_insn_mem(11) := X"2213";    -- bne   $1, $2, 3
            --var_insn_mem(12) := X"0000";
            --var_insn_mem(13) := X"0000";
            --var_insn_mem(14) := X"0000";
            --var_insn_mem(15) := X"3018";    -- store $1, $0, 8
            
        
        elsif (falling_edge(clk)) then
            -- read instructions on the rising clock edge
            var_addr := conv_integer(addr_in);
            insn_out <= var_insn_mem(var_addr);
        end if;

        -- the following are probe signals (for simulation purpose)
        sig_insn_mem <= var_insn_mem;

    end process;
  
end behavioral;
