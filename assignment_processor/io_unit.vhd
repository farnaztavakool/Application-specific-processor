-- Controls when to load data input into special registers, and output control signals
-- Dongzhu Huang
-- April 2021

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_unit is port (
	-- Inputs
	reset : in std_logic;
	clock : in std_logic;
	cpu_in : in std_logic_vector(16 downto 0);
	network_in : in std_logic_vector(19 downto 0);
	busy_in : in std_logic;
	attack_in : in std_logic;
	error_in : in std_logic;
	valid_in : in std_logic;
	status_reg_enable : in std_logic;
	cpu_data_avail : in std_logic;	-- aka send
	net_data_avail : in std_logic;	-- aka recv

	-- Outputs
	busy_out : out std_logic;
	attack_out : out std_logic;
	error_out : out std_logic;
	valid_out : out std_logic;
	write_enable_special : out std_logic;
	reg_2 : out std_logic_vector(15 downto 0);
	reg_3 : out std_logic_vector(15 downto 0);
	reg_4 : out std_logic_vector(15 downto 0)
);
end entity;

architecture behaviour of io_unit is
	signal busy : std_logic;	-- Needs to be read from, hence the need for this signal
begin
	busy_out <= busy;
	status_registers: process(clock, reset) is begin
		if reset = '1' then
			-- Reset case
			busy <= '0';
			attack_out <= '0';
			error_out <= '0';
			valid_out <= '0';

		elsif falling_edge(clock) and status_reg_enable then
			-- Normal case
			busy <= busy_in;
			attack_out <= attack_in;
			error_out <= error_in;
			valid_out <= valid_in;

		end if;
	end process;

	-- Write to special registers when not busy and data is available
	write_enable_special <= not busy and (cpu_data_avail or net_data_avail);

	-- SPECIAL REGISTERS:
	-- $2 contains input data, 16 bits
	-- $3 reserved for parity
	-- $4 contains input tag

	reg_2 <=
		network_in(19 downto 4) when net_data_avail = '1' else
		cpu_in(16 downto 1) when cpu_data_avail = '1' else
		(others => '0');

	reg_3 <=
		"000000000000000" & cpu_in(1) when cpu_data_avail = '1' else
		(others => '0');

	reg_4 <=
		"000000000000" & network_in(3 downto 0) when net_data_avil = '1' else
		(others => '0');

end behaviour;
