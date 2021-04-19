----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16.04.2021 17:40:55
-- Design Name:
-- Module Name: ALU_wrapper - Behavioral
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

entity ALU_wrapper is
  Port (src_a   : in  std_logic_vector(15 downto 0);
        src_b   : in  std_logic_vector(15 downto 0);
        ctr     : in  std_logic_vector(1 downto 0);
        alu_out : out std_logic_vector(15 downto 0));
end ALU_wrapper;

architecture Behavioral of ALU_wrapper is

component mux_4to1_16b is
 port ( mux_select : in  std_logic_vector(1 downto 0);
        data_a     : in  std_logic_vector(15 downto 0);
        data_b     : in  std_logic_vector(15 downto 0);
        data_c     : in  std_logic_vector(15 downto 0);
        data_d     : in  std_logic_vector(15 downto 0);
        data_out   : out std_logic_vector(15 downto 0));
end component;
    component alu_flip is
        port ( rs_in     : in  std_logic_vector(15 downto 0);
            rt_in     : in  std_logic_vector(15 downto 0);
            rd_out    : out std_logic_vector(15 downto 0));
    end component;

    component alu_parity is
        port ( rs_in     : in  std_logic_vector(15 downto 0);
            rt_in     : in  std_logic_vector(15 downto 0);
            rd_out    : out std_logic_vector(15 downto 0));
    end component;

    component alu_rol is
        port ( rs_in     : in  std_logic_vector(15 downto 0);
            rt_in     : in  std_logic_vector(15 downto 0);
            rd_out    : out std_logic_vector(15 downto 0));
    end component;

    component alu_xor is
        port ( rs_in     : in  std_logic_vector(15 downto 0);
            rt_in     : in  std_logic_vector(15 downto 0);
            rd_out    : out std_logic_vector(15 downto 0));
    end component;

    signal rs_in :std_logic_vector(15 downto 0);
    signal rt_in :std_logic_vector(15 downto 0);


    signal rol_res    : std_logic_vector(15 downto 0);
    signal bf_res     : std_logic_vector(15 downto 0);
    signal xor_res    : std_logic_vector(15 downto 0);
    signal parity_res : std_logic_vector(15 downto 0);

    signal empty : std_logic_vector(13 downto 0) := (others => '0');

begin

    --bf_res      <= empty & "00";
    --rol_res     <= empty & "01";
    --xor_res     <= empty & "10";
    --parity_res  <= empty & "11";

    rs_in <= src_a;
    rt_in <= src_b;

    mux_alu_ctr : mux_4to1_16b
    port map ( mux_select => ctr,
               data_a     => bf_res,        -- bf 00
               data_b     => rol_res,       -- rol  01
               data_c     => xor_res,       -- xor 10
               data_d     => parity_res,    -- parity 11
               data_out   => alu_out );


    flip : alu_flip port map
        (   rs_in     => rs_in,
            rt_in     => rt_in,
            rd_out    => bf_res);

      parity : alu_parity port map
        (   rs_in     => rs_in,
            rt_in     => rt_in,
            rd_out    => parity_res);

      alu_rol1: alu_rol port map
        (   rs_in     => rs_in,
            rt_in     => rt_in,
            rd_out    => rol_res);

      alu_xor1: alu_xor port map
        (   rs_in     => rs_in,
            rt_in     => rt_in,
            rd_out    => xor_res);

end Behavioral;
