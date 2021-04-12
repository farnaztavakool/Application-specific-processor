----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2021 20:26:14
-- Design Name: 
-- Module Name: SPupdate - Behavioral
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

--

entity SPupdate is
     port (
        reset            :std_logic;
        op              : in  std_logic_vector(3 downto 0);
        SPcontrol:      in std_logic; 
        currSP:         in integer range 0 to 15;
        nextSP:         out integer range 0 to 15);
end SPupdate;

architecture Behavioral of SPupdate is

    

begin
    process(op,reset)
    begin
        if (reset = '1') then
            nextSP <= 0;
           
        -- handeling the case of underflow
        elsif (SPcontrol = '1') then
            if (currSP = 0) then 
                nextSP <= 0;
            else 
                nextSP <= currSP - 1;
            end if;
            
         else 
            -- handeling the case of overflow
            if (currSP = 15) then 
                nextSP <= 0;
            else
                nextSP <= currSP+1;
            end if;
         end if;
     
    end process;
        


end Behavioral;
