
--rotate left by ker value
-- written by anranli
-- assuming ROL     rd, rs, rt      # ROL  rs by rt and store into rd
-- rotate 4 4 bit chunk to left
library IEEE;
use IEEE.std_logic_1164.all;

entity alu_rol is
    port ( rs_in     : in  std_logic_vector(15 downto 0);
           rt_in     : in  std_logic_vector(15 downto 0);
           rd_out    : out std_logic_vector(15 downto 0));
end alu_rol;

architecture behavioural of alu_rol is

begin
    with rt_in(1 downto 0) select
    rd_out(3 downto 0) <= rs_in(2 downto 0) & rs_in(3) when "01",
                          rs_in(1 downto 0) & rs_in(3 downto 2) when "10",
                          rs_in(0) & rs_in(3 downto 1) when "11",  
                          rs_in(3 downto 0) when others; 
    with rt_in(4 downto 3) select
    rd_out(7 downto 4) <= rs_in(6 downto 4) & rs_in(7) when "01",
                          rs_in(5 downto 4) & rs_in(7 downto 6) when "10",
                          rs_in(4) & rs_in(7 downto 5) when "11",  
                          rs_in(7 downto 4) when others; 
    with rt_in(7 downto 6) select
    rd_out(11 downto 8) <= rs_in(10 downto 8) & rs_in(11) when "01",
                          rs_in(9 downto 8) & rs_in(11 downto 10) when "10",
                          rs_in(8) & rs_in(11 downto 9) when "11",  
                          rs_in(11 downto 8) when others; 
    with rt_in(10 downto 9) select
    rd_out(15 downto 12) <= rs_in(14 downto 12) & rs_in(15) when "01",
                          rs_in(13 downto 12) & rs_in(15 downto 14) when "10",
                          rs_in(12) & rs_in(15 downto 13) when "11",  
                          rs_in(15 downto 12) when others; 
end behavioural;
