---------------------------------------------------------------------------
-- adder_6b.vhd - 6-bit Adder Implementation
-- 
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

entity adder_6b is
    port ( src_a     : in  std_logic_vector(5 downto 0);
           src_b     : in  std_logic_vector(5 downto 0);
           sum       : out std_logic_vector(5 downto 0);
           carry_out : out std_logic );
end adder_6b;

architecture behavioural of adder_6b is

signal sig_result : std_logic_vector(6 downto 0);

begin

    sig_result <= ('0' & src_a) + ('0' & src_b);
    sum        <= sig_result(5 downto 0);
    carry_out  <= sig_result(6);
    
end behavioural;
