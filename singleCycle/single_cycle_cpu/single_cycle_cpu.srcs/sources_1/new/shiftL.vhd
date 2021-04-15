----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.03.2021 21:21:37
-- Design Name: 
-- Module Name: sll - Behavioral
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
USE ieee.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shiftL is
    Port ( Rs : in STD_LOGIC_VECTOR (31 downto 0);
           Rt : in STD_LOGIC_VECTOR (31 downto 0);
           Rd : out STD_LOGIC_VECTOR (31 downto 0));
end shiftL;

architecture Behavioral of shiftL is
    signal convert: unsigned(31 downto 0);
    signal shiftVal: Integer range 0 to 32;
    
begin
    convert <= unsigned(Rs);
    shiftVal <= TO_INTEGER(unsigned(Rt));
    
    Rd <= std_logic_vector(convert sll shiftVal);

end Behavioral;
