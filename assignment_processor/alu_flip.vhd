--flip implementation
--filp    rd, rs, rt      flip rs by rt and store into rd
-- written by anranli

library IEEE;
use IEEE.std_logic_1164.all;

entity alu_flip is
    port ( rs_in     : in  std_logic_vector(15 downto 0);
           rt_in     : in  std_logic_vector(15 downto 0);
           rd_out    : out std_logic_vector(15 downto 0));
end alu_flip;

architecture behavioural of alu_flip is
    
signal tmp : std_logic_vector(15 downto 0);
begin

    with rt_in(12) select
        tmp(3 downto 0) <=  X"f" when '1',
                            X"0" when others;
    with rt_in(13) select
        tmp(7 downto 4) <=  X"f" when '1',
                            X"0" when others;
    with rt_in(14) select
        tmp(11 downto 8) <= X"f" when '1',
                            X"0" when others;
    with rt_in(15) select
        tmp(15 downto 12) <=X"f" when '1',
                            X"0" when others;
    rd_out <= tmp xor rs_in;
end behavioural;