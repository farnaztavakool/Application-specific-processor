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
            
            -- test ALU
            var_insn_mem(0)  := X"1201";    -- load     $2, 1   -- load dummy data
            var_insn_mem(1)  := X"1100";    -- load     $1, 0   -- load secret key
            var_insn_mem(2)  := X"0000";    -- nop
            var_insn_mem(3)  := X"7235";    -- parity   $5, $2, $3
            var_insn_mem(4)  := X"4215";    -- bit_flip $5, $2, $1
            var_insn_mem(5)  := X"5216";    -- rol      $6, $2, $1
            var_insn_mem(6)  := X"6207";    -- xor      $7, $2, $0
            var_insn_mem(7)  := X"0000";    -- nop
            var_insn_mem(8)  := X"0000";    -- nop
            var_insn_mem(9)  := X"0000";    -- nop
            var_insn_mem(10) := X"0000";    -- nop
            var_insn_mem(11) := X"0000";    -- nop
            var_insn_mem(12) := X"0000";    -- nop
            var_insn_mem(13) := X"0000";    -- nop
            var_insn_mem(14) := X"0000";    -- nop
            var_insn_mem(15) := X"0000";    -- nop
            
            
            -- do_send
            --var_insn_mem(0)  := X"1010";    -- load     $1, $0, 0   -- load secret key
            --var_insn_mem(1)  := X"1021";    -- load     $2, $0, 1   -- load dummy data
            --var_insn_mem(2)  := X"8008";    -- set_sig 1000
            --var_insn_mem(3)  := X"0000";    -- nop
            --var_insn_mem(4)  := X"7235";    -- parity   $5, $2, $3
            --var_insn_mem(5)  := X"2520";    -- bne      $5, $2, error=0
            --var_insn_mem(6)  := X"0000";    -- nop
            --var_insn_mem(7)  := X"4215";    -- bit_flip $5, $2, $1
            --var_insn_mem(8)  := X"0000";    -- nop
            --var_insn_mem(9)  := X"0000";    -- nop
            --var_insn_mem(10) := X"5516";    -- rol      $6, $5, $1
            --var_insn_mem(11) := X"0000";    -- nop
            --var_insn_mem(12) := X"0000";    -- nop
            --var_insn_mem(13) := X"6607";    -- xor      $7, $6, $0
            --var_insn_mem(14) := X"0000";    -- nop
            --var_insn_mem(15) := X"0000";    -- nop
            --var_insn_mem(16) := X"3020";    -- store $2, $0, out_location_data = 0
            --var_insn_mem(17) := X"3070";    -- store $7, $0, out_location_tag = 0
            --var_insn_mem(18) := X"2100";    -- bne      $1, $0, while=0
            --var_insn_mem(19) := X"0000";    -- nop
            
        
        elsif (falling_edge(clk)) then
            -- read instructions on the rising clock edge
            var_addr := conv_integer(addr_in);
            insn_out <= var_insn_mem(var_addr);
        end if;

        -- the following are probe signals (for simulation purpose)
        sig_insn_mem <= var_insn_mem;

    end process;
  
end behavioral;
