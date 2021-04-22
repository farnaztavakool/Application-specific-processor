library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

entity alu_components_TB is
end alu_components_TB;


architecture behave of alu_components_TB is

    constant c_CLOCK_PERIOD : time := 2 ns; 


    signal r_CLOCK     : std_logic := '0';
    signal r_reset    : std_logic := '0';

    signal rs_in :std_logic_vector(15 downto 0);
    signal rt_in :std_logic_vector(15 downto 0);
    signal rd_out1 :std_logic_vector(15 downto 0);
    signal rd_out2 :std_logic_vector(15 downto 0);
    signal rd_out3 :std_logic_vector(15 downto 0);
    signal rd_out4 :std_logic_vector(15 downto 0);
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
begin
    p_CLK_GEN : process is
        begin
          wait for c_CLOCK_PERIOD/2;
          r_CLOCK <= not r_CLOCK;
        end process p_CLK_GEN;
    
    process(r_CLOCK)
    variable i : positive :=0;
    variable j : positive :=255;
    begin
        i:=i+256;
        j:=j+512;
        rs_in <= conv_std_logic_vector(i,16);
        rt_in <= conv_std_logic_vector(j,16);
    end process;

    flip : alu_flip port map
             ( rs_in     => rs_in,
               rt_in     => rt_in,
               rd_out    => rd_out1);
    

    parity : alu_parity port map
            ( rs_in     => rs_in,
            rt_in     => rt_in,
            rd_out    => rd_out2);

    alu_rol1: alu_rol port map
            ( rs_in     => rs_in,
              rt_in     => rt_in,
              rd_out    => rd_out3);

    alu_xor1: alu_xor port map
            ( rs_in     => rs_in,
              rt_in     => rt_in,
              rd_out    => rd_out4);
    
end behave;