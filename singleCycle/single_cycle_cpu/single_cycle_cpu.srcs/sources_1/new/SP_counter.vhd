----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2021 21:07:23
-- Design Name: 
-- Module Name: SP_counter - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SP_counter is
    Port (
        reset:    in std_logic; 
        op              : in  std_logic_vector(3 downto 0);
        nextSP: in integer range 0 to 15;
        currSP: out integer range 0 to 15);
end SP_counter;

architecture Behavioral of SP_counter is

begin
process(nextSP, op, reset)
    begin
          
        if (reset = '1') then
            -- initial values of the registers - reset to zeroes
            
            currSP <= 0;
            

        else 
            -- register write on the falling clock edge
            currSP <= nextSP;
            --currSP <= 0;
        end if;
end process;
    

end Behavioral;
