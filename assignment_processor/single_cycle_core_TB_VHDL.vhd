library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity Single_cycle_core_TB_VHDL is
end Single_cycle_core_TB_VHDL;


architecture behave of Single_cycle_core_TB_VHDL is

    -- 1 GHz = 2 nanoseconds period
    constant c_CLOCK_PERIOD : time := 2 ns;


    signal r_CLOCK     : std_logic := '0';
    signal r_reset    : std_logic := '0';
    signal send       : std_logic := '0';
    signal recv       : std_logic := '0';
    signal network_in : std_logic_vector(19 downto 0) := (others => '0'); -- data read from the network
    signal cpu_in     : std_logic_vector(16 downto 0) := (others => '0'); -- data read from processor
    signal attack     : std_logic := '0';
    signal error      : std_logic := '0';
    signal network_out : std_logic_vector(19 downto 0) := (others => '0'); -- data sent to network
    signal cpu_out     : std_logic_vector(15 downto 0) := (others => '0'); -- data sent to processor
    signal toggle_bit   : std_logic := '0';
    signal busy         : std_logic := '0';
    signal valid        : std_logic;
    --file file_vectors_network: text;
    --file file_vectors_cpu :text;



-- Component declaration for the Unit Under Test (UUT)
-- if rising_edge && ! busy --> read file & check  ?
-- if rising_edge && ! busy && check --> send file
component single_cycle_core is
         port (
           reset             : in   std_logic;
           clk               : in   std_logic;
           send              : in   std_logic;
           recv              : in   std_logic;
           network_in        : in   std_logic_vector(19 downto 0); -- 4 tag + 16 bit
           cpu_in            : in   std_logic_vector(16 downto 0); -- 16 bita+ parity

           busy              : out  std_logic;
           attack            : out  std_logic;
           error             : out  std_logic;
           valid             : buffer std_logic;
           network_out       : out  std_logic_vector(19 downto 0);
           cpu_out           : out  std_logic_vector(15 downto 0));


end component ;


begin
-- Instantiate the Unit Under Test (UUT)
UUT : single_cycle_core
    port map (
    reset    => r_reset,
    clk     => r_CLOCK,
    send    => send,
    recv   => recv,
    network_in => network_in,
    cpu_in    => cpu_in,
    busy        => busy,
    attack   => attack,
    error   => error,
    valid  => valid,
    network_out => network_out,
    cpu_out     => cpu_out

    );

p_CLK_GEN : process is
begin
    wait for c_CLOCK_PERIOD/2;
    r_CLOCK <= not r_CLOCK;
end process p_CLK_GEN;

process                               -- main testing
begin
    r_reset <= '0';

    wait for 3*c_CLOCK_PERIOD ;
    r_reset <= '1';

    wait for 3*c_CLOCK_PERIOD ;
    r_reset <= '0';

    wait for 2 sec;

end process;

process(r_clock, busy)
    variable v_line_network : line;
    variable  v_line_cpu    :line;
    variable cpu_data       :std_logic_vector(16 downto 0);
    variable network_data   :std_logic_vector(19 downto 0);
    file file_vectors_network :  text open read_mode is "network.txt";  
    file file_vectors_cpu :  text open read_mode is "cpu.txt";
    variable stall        :integer:=0;
begin

    --file_open(file_VECTORS_network, "network",  read_mode);
    --file_open(file_VECTORS_cpu, "cpu",  read_mode);
    --file file_vectors_network :  text open read_mode is "network";  
   -- file file_vectors_network     : text open read_mode is "network";
    if falling_edge(r_clock) and busy = '0' then
        if (send = '1' and stall =  0) then 
            send <= '0';
        elsif (recv = '1' and stall = 0) then
            recv <= '0';
        
        end if;
    end if ;   
    if rising_edge(r_clock) and busy = '0' and r_reset = '0'  then
       
        if toggle_bit = '0' and stall = 0 then
            if (not endfile(file_vectors_network)) then
                readline(file_VECTORS_network, v_line_network);
                read(v_LINE_network, network_data);
                network_in <= network_data;
                toggle_bit <= '1';
                send <= '0';
                recv <= '1';
            else
                toggle_bit <= '1';
                recv       <= '0';
                --send <= '0';
            end if;
        elsif stall = 0 then
            if (not endfile(file_vectors_cpu)) then
                readline(file_VECTORS_cpu, v_line_cpu);
                read(v_LINE_cpu, cpu_data);
                cpu_in <= cpu_data;
                toggle_bit <= '0';
                send <= '1';
                recv <= '0';
            else
                toggle_bit <= '0';
                send <= '0';
                --send <= '0';
            end if;
        end if;
         stall:= stall+1;
        if (stall = 3) then 
            stall := 0;
        end if;
    end if;
   
end process;

end behave;
