----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2021 20:44:17
-- Design Name: 
-- Module Name: forwarding_unit - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity forwarding_unit is
    Port (mem_reg_write : in std_logic;
          wb_reg_write  : in std_logic;
          mem_rd        : in std_logic_vector(3 downto 0);
          wb_rd         : in std_logic_vector(3 downto 0);
          ex_rs         : in std_logic_vector(3 downto 0);
          ex_rt         : in std_logic_vector(3 downto 0);
          frwd_ctr_a    : out std_logic_vector(1 downto 0);
          frwd_ctr_b    : out std_logic_vector(1 downto 0));
end forwarding_unit;

architecture Behavioral of forwarding_unit is

    -- 00 none
    -- 01 none
    -- 10 mem forward
    -- 11 wb forward
    
    signal sig_mem_a : std_logic;
    signal sig_wb_a  : std_logic; 
    signal sig_mem_b : std_logic;
    signal sig_wb_b  : std_logic; 

begin

    
    sig_mem_a <= '1' when (mem_reg_write = '1' and 
                           mem_rd /= "0000" and 
                           ex_rs = mem_rd) else 
                 '0';
                 
    sig_mem_b <= '1' when (mem_reg_write = '1' and 
                           mem_rd /= "0000" and 
                           ex_rt = mem_rd) else 
                 '0';
    
    sig_wb_a <= '1' when (wb_reg_write = '1' and
                          wb_rd /= "0000" and 
                          (mem_reg_write = '0' or mem_rd /= ex_rs) and 
                          wb_rd = ex_rs) else 
                 '0';
                 
    sig_wb_b <= '1' when (wb_reg_write = '1' and
                          wb_rd /= "0000" and 
                          (mem_reg_write = '0' or mem_rd /= ex_rt) and 
                          wb_rd = ex_rt) else 
                 '0';
    
    -- ctr signals --
    frwd_ctr_a(1) <= '1' when (sig_wb_a = '1' or 
                               sig_mem_a = '1') else 
                     '0';
                 
    frwd_ctr_a(0) <= '1' when (sig_wb_a = '1') else 
                     '0';
                     
    frwd_ctr_b(1) <= '1' when (sig_wb_b = '1' or 
                               sig_mem_b = '1') else 
                     '0';
                 
    frwd_ctr_b(0) <= '1' when (sig_wb_b = '1') else 
                     '0';
    

end Behavioral;
