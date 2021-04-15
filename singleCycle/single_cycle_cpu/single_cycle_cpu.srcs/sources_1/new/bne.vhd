----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2021 05:37:13
-- Design Name: 
-- Module Name: bne - Behavioral
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
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bne is
--  Port ( );
    port (ALUOperation: in  std_logic_vector(3 downto 0);
        condition :in STD_LOGIC_VECTOR (15 downto 0);
        where: in STD_LOGIC_VECTOR (3 downto 0);
        current: in std_logic_vector(3 downto 0);
        breach:  out std_logic;
        output: out STD_LOGIC_VECTOR (3 downto 0));
end bne;

architecture Behavioral of bne is
signal check1, check2: Integer;
signal sig_result : std_logic_vector(4 downto 0);

begin
    process(ALUOperation,current,condition)
    begin
        case ALUOperation is
            when "0101" =>
                
                if (condition /= "0000000000000000") then
                    sig_result <= ('0' & current)  + ('0' & where);
                    --('0' & "0001")
                    output <= sig_result (3 downto 0);
                    breach <= '1';
                else 
                    sig_result <= ('0' & current) + ('0' & "0001") ;
                    output <= sig_result(3 downto 0);
                    breach <= '0';
                end if;
            
          when others =>
            sig_result <= ('0' & current) + ('0' & "0001") ;
            output <= sig_result(3 downto 0);
            breach <= '0';    
        end case;
    end process;

end Behavioral;
