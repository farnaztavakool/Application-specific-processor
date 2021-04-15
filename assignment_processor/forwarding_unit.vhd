library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is port (
	mem_reg_write : in std_logic;
	mem_rd : in std_logic_vector(3 downto 0);
	
	wb_reg_write : in std_logic;
	wb_rd : in std_logic_vector(3 downto 0);
	
	ex_rs : in std_logic_vector(3 downto 0);
	ex_rt : in std_logic_vector(3 downto 0);
	
	
	alu_a_forward : out std_logic_vector(1 downto 0);
	alu_b_forward : out std_logic_vector(1 downto 0)
);
end entity;

architecture behavioural of forwarding_unit is
	constant FORWARD_NONE : std_logic_vector(1 downto 0) := "00";
	constant FORWARD_MEM : std_logic_vector(1 downto 0) := "01";
	constant FORWARD_WB : std_logic_vector(1 downto 0) := "10";

begin
	process(mem_reg_write, mem_rd, wb_reg_write, wb_rd, ex_rs, ex_rt) begin
		alu_a_forward <= FORWARD_NONE;
		alu_b_forward <= FORWARD_NONE;
		
		-- Forwarding from mem
		if mem_reg_write = '1' and
			mem_rd /= std_logic_vector(to_unsigned(0, mem_rd'length)) and
			mem_rd = ex_rs then
			-- Forward mem data to alu a
				alu_a_forward <= FORWARD_MEM;
		end if;
		
		if mem_reg_write = '1' and
			mem_rd /= std_logic_vector(to_unsigned(0, mem_rd'length)) and
			mem_rd = ex_rt then
			-- Forward mem data to alu b
				alu_b_forward <= FORWARD_MEM;
		end if;
		
		-- Forwarding from wb
		if wb_reg_write = '1' and
			wb_rd /= std_logic_vector(to_unsigned(0, wb_rd'length)) and
			(mem_reg_write = '0' or mem_rd /= ex_rs) and
			wb_rd = ex_rs then
			-- Forward wb to alu a
				alu_a_forward <= FORWARD_WB;
		end if;

		if wb_reg_write = '1' and
			wb_rd /= std_logic_vector(to_unsigned(0, wb_rd'length)) and
			(mem_reg_write = '0' or mem_rd /= ex_rt) and
			wb_rd = ex_rt then
			-- Forward wb to alu a
				alu_b_forward <= FORWARD_WB;
		end if;

	end process;
end;