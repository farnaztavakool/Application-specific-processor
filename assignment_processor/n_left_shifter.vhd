---------------------------------------------------------------------------
-- n_shift_left - 16-bit Left Shifter Implementation
--
--
-- Copyright (C) 2006 by Ava Williams 
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity n_left_shifter is
    port ( src_a     : in  std_logic_vector(15 downto 0);
           src_b     : in  std_logic_vector(15 downto 0);
           shift     : out std_logic_vector(15 downto 0));
end n_left_shifter;

architecture behavioural of n_left_shifter is

signal sig_result : std_logic_vector(15 downto 0);
signal zeros      : std_logic_vector(15 downto 0) := (others => '0');
signal n          : integer;

begin

    n <= to_integer(unsigned(src_b));
    shift <= sig_result;
    sig_result <= std_logic_vector(shift_left(unsigned(src_a), n));
    
end behavioural;
