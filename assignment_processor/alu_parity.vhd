--parity  rd, rs, rt      find the parity of rs, check this result with rt(0), store result in rd(0)
--assumint even is 0 odd is 1
--parity implementation
-- written by anranli

library IEEE;
use IEEE.std_logic_1164.all;

entity alu_parity is
    port ( rs_in     : in  std_logic_vector(15 downto 0);
           rt_in     : in  std_logic_vector(15 downto 0);
           rd_out    : out std_logic_vector(15 downto 0));
end alu_parity;

architecture behavioural of alu_parity is
    signal tmp : std_logic_vector(3 downto 0);

begin
    --could be changed with using 15 XORs
    tmp<= rs_in(15 downto 12) xor rs_in(11 downto 8) xor rs_in(7 downto 4) xor rs_in(3 downto 0);
    rd_out(0)<=tmp(3)xor tmp(2) xor tmp(1) xor tmp(0);
    rd_out(15 downto 1)<= (others=>'0');
end behavioural;