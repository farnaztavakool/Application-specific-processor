----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2021 22:13:32
-- Design Name: 
-- Module Name: mux_4to1_16b - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux_4to1_16b is
 port ( mux_select : in  std_logic_vector(1 downto 0);
        data_a     : in  std_logic_vector(15 downto 0);
        data_b     : in  std_logic_vector(15 downto 0);
        data_c     : in  std_logic_vector(15 downto 0);
        data_d     : in  std_logic_vector(15 downto 0);
        data_out   : out std_logic_vector(15 downto 0));
end mux_4to1_16b;

architecture Behavioral of mux_4to1_16b is

begin

with mux_select select
    data_out <= data_a when "00", 
			    data_b when "01",
				data_c when "10",
				data_d when others; -- "11"

end Behavioral;
