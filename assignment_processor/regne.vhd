----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2021 22:36:50
-- Design Name: 
-- Module Name: regne - Behavioral
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


-- register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- n-bit register with synchronous reset and enable
entity regne is
	generic( N : integer := 16 ) ;
	port   (D 		: in 	std_logic_vector(N-1 downto 0);
			Resetn	: in	std_logic;
			clk 	: in 	std_logic;
			Q 		: out 	std_logic_vector(N-1 downto 0));
end regne;

architecture Behavior of regne is
begin
	process
	begin
		wait until rising_edge(clk);
		if (Resetn = '1') then
			Q <= (others => '0');
		else
			Q <= D;
		end if;
	end process;
	
end Behavior;
