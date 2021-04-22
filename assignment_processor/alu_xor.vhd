
--XOR implementation
-- written by anranli
-- assuming XOR     rd, rs, rt      rd is store register, rs is input data
-- XOR every 4 bit in rs
library IEEE;
use IEEE.std_logic_1164.all;

entity alu_xor is
    port ( rs_in     : in  std_logic_vector(15 downto 0);
           rt_in     : in  std_logic_vector(15 downto 0);
           rd_out    : out std_logic_vector(15 downto 0));
end alu_xor;

architecture behavioural of alu_xor is

begin
    rd_out(3 downto 0)<= rs_in(15 downto 12) xor rs_in(11 downto 8) xor rs_in(7 downto 4) xor rs_in(3 downto 0);
    rd_out(15 downto 4)<= (others=> '0');
end behavioural;