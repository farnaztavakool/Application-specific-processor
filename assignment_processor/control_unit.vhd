---------------------------------------------------------------------------
-- control_unit.vhd - Control Unit Implementation
--
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
--
--  control signals:
--     reg_dst    : asserted for ADD instructions, so that the register
--                  destination number for the 'write_register' comes from
--                  the rd field (bits 3-0).
--     reg_write  : asserted for ADD and LOAD instructions, so that the
--                  register on the 'write_register' input is written with
--                  the value on the 'write_data' port.
--     alu_src    : asserted for LOAD and STORE instructions, so that the
--                  second ALU operand is the sign-extended, lower 4 bits
--                  of the instruction.
--     alu_ctr    : asserted for add or minus instructions, so that the
--                  result sent to memory is that of the add instruction
--                  when deasserted the sll instruction is sent to memory
--     mem_write  : asserted for STORE instructions, so that the data
--                  memory contents designated by the address input are
--                  replaced by the value on the 'write_data' input.
--     mem_to_reg : asserted for LOAD instructions, so that the value fed
--                  to the register 'write_data' input comes from the
--                  data memory.
--    alu_minus   : asserted to make the adder component perform a subtraction
--                  of src_b from src_a.
--    branch      : asserted in the case of a branch instruction, used in
--                  in branching logic
--
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

entity control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);

           reg_dst    : out std_logic;
           reg_write  : out std_logic;
           alu_src    : out std_logic;
           alu_ctr    : out std_logic_vector(1 downto 0);
           mem_write  : out std_logic;
           mem_to_reg : out std_logic;
           branch     : out std_logic;
           status_reg_write_enable : out std_logic
    );
end control_unit;

architecture behavioural of control_unit is

constant OP_LOAD   : std_logic_vector(3 downto 0) := "0001";
constant OP_BNE    : std_logic_vector(3 downto 0) := "0010";
constant OP_STORE  : std_logic_vector(3 downto 0) := "0011";
constant OP_BF     : std_logic_vector(3 downto 0) := "0100";    -- TODO
constant OP_ROL    : std_logic_vector(3 downto 0) := "0101";    -- TODO
constant OP_XOR    : std_logic_vector(3 downto 0) := "0110";    -- TODO
constant OP_PARITY : std_logic_vector(3 downto 0) := "0111";    -- TODO
constant OP_SETSIG : std_logic_vector(3 downto 0) := "1000";    -- TODO




begin

    reg_dst    <= '1' when (opcode = OP_ROL
                            or opcode = OP_BF
                            or opcode = OP_XOR
                            or opcode = OP_PARITY) else
                  '0';

    reg_write  <= '1' when (opcode = OP_LOAD
                            or opcode = OP_ROL
                            or opcode = OP_BF
                            or opcode = OP_XOR
                            or opcode = OP_PARITY) else
                  '0';

    alu_src    <= '1' when (opcode = OP_LOAD
                           or opcode = OP_STORE) else
                  '0';

    mem_write  <= '1' when opcode = OP_STORE else
                  '0';

    mem_to_reg <= '1' when opcode = OP_LOAD else
                  '0';

    branch     <= '1' when opcode = OP_BNE else
                  '0';

    status_reg_write_enable <=
        '1' when opcode = OP_SETSIG else
        '0';

    -- alu ctr
    process (opcode)
    begin
        if (opcode = OP_BF) then
            alu_ctr <= "00";

        elsif (opcode = OP_ROL) then
            alu_ctr <= "01";

        elsif (opcode = OP_XOR) then
            alu_ctr <= "10";

        else -- OP_PARITY
            alu_ctr <= "11";

        end if;
    end process;

end behavioural;
