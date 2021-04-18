---------------------------------------------------------------------------
-- single_cycle_core.vhd - A Poorly named 5-Stage Pipelined Processor
--
-- Instruction Set Architecture (ISA) for the single-cycle-core:
--   Each instruction is 16-bit wide, with four 4-bit fields.
--
--     no-op
--        # no operation or to signal end of program
--        # format:  | opcode = 0 |  0   |  0   |   0    |
--
--     load  rt, rs, offset
--        # load data at memory location (rs + offset) into rt
--        # format:  | opcode = 1 |  rs  |  rt  | offset |
--
--     store rd, rs, offset
--        # store data rd into memory location (rs + offset)
--        # format:  | opcode = 3 |  rs  |  rd  | offset |
--
--     add   rd, rs, rt
--        # rd <- rs + rt
--        # format:  | opcode = 8 |  rs  |  rt  |   rd   |
--
--     sll   rd, rs, rt
--        # rd <- rs << rt
--        # format:  | opcode = 5 |  rs  |  rt  |   rd   |
--
--     slli  rd, rs, imm
--        # rd <- rs << imm
--        # format:  | opcode = 5 |  rs  |  rd  |  imm   |
--
--     bne rs, rt, offset
--        # if rd != rs : PC = offset
--        # format:  | opcode = 2 |  rs  |  rt  | offset |
--
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity single_cycle_core is
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
           network_out       : out  std_logic_vector(19 downto 0);
           cpu_out           : out  std_logic_vector(15 downto 0));
end single_cycle_core;

architecture structural of single_cycle_core is

component program_counter is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(4 downto 0);
           addr_out : out std_logic_vector(4 downto 0) );
end component;

component instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(4 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end component;

component sign_extend_4to16 is
    port ( data_in  : in  std_logic_vector(3 downto 0);
           data_out : out std_logic_vector(15 downto 0) );
end component;

component mux_2to1_4b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(3 downto 0);
           data_b     : in  std_logic_vector(3 downto 0);
           data_out   : out std_logic_vector(3 downto 0) );
end component;

component mux_2to1_5b is
    port ( mux_select : in  std_logic;
               data_a     : in  std_logic_vector(4 downto 0);
               data_b     : in  std_logic_vector(4 downto 0);
               data_out   : out std_logic_vector(4 downto 0) );
end component;

component mux_2to1_16b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(15 downto 0);
           data_b     : in  std_logic_vector(15 downto 0);
           data_out   : out std_logic_vector(15 downto 0) );
end component;

component control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);
           reg_dst    : out std_logic;
           reg_write  : out std_logic;
           alu_src    : out std_logic;
           alu_ctr    : out std_logic_vector(1 downto 0);
           mem_write  : out std_logic;
           mem_to_reg : out std_logic;
           branch     : out std_logic;
           status_reg_write_enable : out std_logic );
end component;

component register_file is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           read_register_a : in  std_logic_vector(3 downto 0);
           read_register_b : in  std_logic_vector(3 downto 0);
           write_enable    : in  std_logic;
           write_register  : in  std_logic_vector(3 downto 0);
           write_data      : in  std_logic_vector(15 downto 0);
           write_enable_special : in std_logic;
           reg_2_write_data : in std_logic_vector(15 downto 0);
           reg_3_write_data : in std_logic_vector(15 downto 0);
           reg_4_write_data : in std_logic_vector(15 downto 0);

           read_data_a     : out std_logic_vector(15 downto 0);
           read_data_b     : out std_logic_vector(15 downto 0) );
end component;

component adder_4b is
      port ( src_a     : in  std_logic_vector(4 downto 0);
           src_b     : in  std_logic_vector(4 downto 0);
           sum       : out std_logic_vector(4 downto 0);
           carry_out : out std_logic );
end component;

component data_memory is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(15 downto 0);
           addr_in      : in  std_logic_vector(3 downto 0);
           data_out     : out std_logic_vector(15 downto 0) );
end component;

component regne is
	generic( N : integer := 16 ) ;
	port   (D 		: in 	std_logic_vector(N-1 downto 0);
			Resetn	: in	std_logic;
			clk 	: in 	std_logic;
			Q 		: out 	std_logic_vector(N-1 downto 0));
end component;

component forwarding_unit is
    Port (mem_reg_write : in std_logic;
          wb_reg_write  : in std_logic;
          mem_rd        : in std_logic_vector(3 downto 0);
          wb_rd         : in std_logic_vector(3 downto 0);
          ex_rs         : in std_logic_vector(3 downto 0);
          ex_rt         : in std_logic_vector(3 downto 0);
          frwd_ctr_a    : out std_logic_vector(1 downto 0);
          frwd_ctr_b    : out std_logic_vector(1 downto 0));
end component;

component mux_4to1_16b is
 port ( mux_select : in  std_logic_vector(1 downto 0);
        data_a     : in  std_logic_vector(15 downto 0);
        data_b     : in  std_logic_vector(15 downto 0);
        data_c     : in  std_logic_vector(15 downto 0);
        data_d     : in  std_logic_vector(15 downto 0);
        data_out   : out std_logic_vector(15 downto 0));
end component;

component io_unit is port (
	-- Inputs
	reset : in std_logic;
	clock : in std_logic;
	cpu_in : in std_logic_vector(16 downto 0);
	network_in : in std_logic_vector(19 downto 0);
	busy_in : in std_logic;
	attack_in : in std_logic;
	error_in : in std_logic;
	valid_in : in std_logic;
	status_reg_write_enable : in std_logic;
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
end component;
component ALU_wrapper is
  Port (src_a   : in  std_logic_vector(15 downto 0);
        src_b   : in  std_logic_vector(15 downto 0);
        ctr     : in  std_logic_vector(1 downto 0);
        alu_out : out std_logic_vector(15 downto 0));
end component;

-- signal labelling scheme: if it exisits in a stage, then that stage will be in the name
-- this is particularly needed when the signal is propogated through to other stages
signal sig_next_pc              : std_logic_vector(4 downto 0);
signal sig_curr_pc              : std_logic_vector(4 downto 0);
signal sig_one_4b               : std_logic_vector(4 downto 0);
signal sig_pc_inc               : std_logic_vector(4 downto 0);
signal sig_branch_pc            : std_logic_vector(4 downto 0);
signal sig_pc_carry_out         : std_logic;
signal sig_pc_branch_carry_out  : std_logic;
signal sig_insn                 : std_logic_vector(15 downto 0);
signal sig_sign_extended_offset : std_logic_vector(15 downto 0);
signal sig_reg_dst              : std_logic;
signal sig_reg_write            : std_logic;
signal sig_alu_src              : std_logic;
signal sig_branch               : std_logic;
signal sig_alu_ctr              : std_logic_vector(1 downto 0);
signal sig_mem_write            : std_logic;
signal sig_mem_to_reg           : std_logic;
signal sig_write_register       : std_logic_vector(3 downto 0);
signal sig_write_data           : std_logic_vector(15 downto 0);
signal sig_read_data_a          : std_logic_vector(15 downto 0);
signal sig_read_data_b          : std_logic_vector(15 downto 0);
signal sig_alu_src_b            : std_logic_vector(15 downto 0);
signal sig_alu_ctr_out          : std_logic_vector(15 downto 0);
signal sig_data_mem_out         : std_logic_vector(15 downto 0);
-- pipeline register signals
-- id
signal sig_id_insn              : std_logic_vector(15 downto 0);
signal sig_xor_same             : std_logic;
signal sig_xor                  : std_logic_vector(15 downto 0);
signal sig_id_write_enable_special : std_logic;
signal sig_id_special_reg_data  : std_logic_vector(47 downto 0);
signal sig_id_status_reg_write_enable : std_logic;
signal sig_xor_branch_mux       : std_logic;
signal sig_addr                 : std_logic_vector(15 downto 0);
-- ex
signal sig_ex_in                : std_logic_vector(94 downto 0);
signal sig_ex_out               : std_logic_vector(94 downto 0);
signal sig_ex_insn              : std_logic_vector(15 downto 0);
signal sig_ex_reg_dst           : std_logic;
signal sig_ex_reg_write         : std_logic;
signal sig_ex_alu_src           : std_logic;
signal sig_ex_alu_ctr           : std_logic_vector(1 downto 0);
signal sig_ex_mem_write         : std_logic;
signal sig_ex_mem_to_reg        : std_logic;
signal sig_ex_alu_minus         : std_logic;
signal sig_ex_read_data_a       : std_logic_vector(15 downto 0);
signal sig_ex_read_data_b       : std_logic_vector(15 downto 0);
signal sig_ex_reg_1             : std_logic_vector(3 downto 0);
signal sig_ex_reg_2             : std_logic_vector(3 downto 0);
signal sig_ex_sign_extended_offset : std_logic_vector(15 downto 0);
signal sig_ex_addr                 : std_logic_vector(15 downto 0);
-- mem
signal sig_mem_in               : std_logic_vector(70 downto 0);
signal sig_mem_out              : std_logic_vector(70 downto 0);
signal sig_mem_insn             : std_logic_vector(15 downto 0);
signal sig_mem_mem_write        : std_logic;
signal sig_mem_mem_to_reg       : std_logic;
signal sig_mem_write_register   : std_logic_vector(3 downto 0);
signal sig_mem_alu_ctr_out      : std_logic_vector(15 downto 0);
signal sig_mem_read_data_b      : std_logic_vector(15 downto 0);
signal sig_mem_reg_write        : std_logic;
signal sig_mem_addr                 : std_logic_vector(15 downto 0);
-- wb
signal sig_wb_in                : std_logic_vector(53 downto 0);
signal sig_wb_out               : std_logic_vector(53 downto 0);
signal sig_wb_insn              : std_logic_vector(15 downto 0);
signal sig_wb_mem_to_reg        : std_logic;
signal sig_wb_data_mem_out      : std_logic_vector(15 downto 0);
signal sig_wb_alu_ctr_out       : std_logic_vector(15 downto 0);
signal sig_wb_write_register    : std_logic_vector(3 downto 0);
signal sig_wb_write_data        : std_logic_vector(15 downto 0);
signal sig_wb_reg_write         : std_logic;
-- forwarding
signal sig_frwd_ctr_a           : std_logic_vector(1 downto 0);
signal sig_frwd_ctr_b           : std_logic_vector(1 downto 0);
signal sig_frwd_a               : std_logic_vector(15 downto 0);
signal sig_frwd_b               : std_logic_vector(15 downto 0);

-- Hardcoded instruction addresses for send/recieve

signal do_recv_addr              : std_logic_vector(4 downto 0);
signal do_send_addr              : std_logic_vector(4 downto 0);
signal pc_mux_select             : std_logic_vector(4 downto 0);

-- mux results
signal sig_next_pc_mux            :std_logic_vector(4 downto 0);
signal mux_recv_next              :std_logic_vector(4 downto 0);
signal mux_next_send              :std_logic_vector(4 downto 0);

-- mux signals
signal recv_busy                  :std_logic;
signal send_busy                  :std_logic;


-- busy|attack|error|valid
signal set_signal                 :std_logic_vector(3 downto 0);



begin

--    out_sig_if <= sig_id_insn;

    recv_busy <= recv and (not set_signal(3));
    send_busy <= send and (not set_signal(3));

    busy <= set_signal(3);
    attack <= set_signal(2);
    error <= set_signal(1);
    attack <= set_signal(0);


    -- IF: instruction fetch
    sig_one_4b <= "00001";
    
    -- address is 11
    do_recv_addr <= "01011";
    
    -- address is 27
    do_send_addr <= "11011";

    pc : program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc,
               addr_out => sig_curr_pc );

    next_pc : adder_4b
    port map ( src_a     => sig_curr_pc,
               src_b     => sig_one_4b,
               sum       => sig_pc_inc,
               carry_out => sig_pc_carry_out );

    -- branch add is 3 bits need to concat a zero bit at the begining
    sig_branch_pc <= '0' & sig_id_insn(3 downto 0);
    



    -- next_pc
    next_pc_mux: mux_2to1_5b
    port map ( mux_select => sig_xor_branch_mux,
               data_a     => sig_pc_inc,
               data_b     => sig_branch_pc,
               data_out   => sig_next_pc_mux );


    -- recv mux
    recv_pc_mux: mux_2to1_5b
    port map ( mux_select => recv_busy,
               data_a     => sig_next_pc_mux,
               data_b     => do_recv_addr,
               data_out   => mux_recv_next );

    -- send mux
    send_pc_mux: mux_2to1_5b
    port map ( mux_select => send_busy,
               data_a     => mux_recv_next,
               data_b     => do_send_addr,
               data_out   => sig_next_pc );

    insn_mem : instruction_memory
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_curr_pc,
               insn_out => sig_insn );


    -- ID: instruction decode

    -- IF/ID state register
    --  sig_insn    15-0

    if_id_reg : regne
    generic map( N => 16 )
    port map ( D        => sig_insn,
			   Resetn	=> reset,
			   clk    	=> clk,
			   Q 		=> sig_id_insn );


	-- early branch checking
	sig_xor <= sig_read_data_a xor sig_read_data_b;
    sig_xor_same <= '1'     when (sig_xor = "0000000000000000") else
                    '0';
    sig_xor_branch_mux <= NOT sig_xor_same and sig_branch;

    -- TODO can remove
    sign_extend : sign_extend_4to16
    port map ( data_in  => sig_id_insn(3 downto 0),
               data_out => sig_addr );

    ctrl_unit : control_unit
    port map ( opcode     => sig_id_insn(15 downto 12),
               reg_dst    => sig_reg_dst,
               reg_write  => sig_reg_write,
               alu_src    => sig_alu_src,
               alu_ctr    => sig_alu_ctr,
               mem_write  => sig_mem_write,
               mem_to_reg => sig_mem_to_reg,
               branch     => sig_branch,
               status_reg_write_enable => sig_id_status_reg_write_enable );

    reg_file : register_file
    port map ( reset           => reset,
               clk             => clk,
               read_register_a => sig_id_insn(11 downto 8),
               read_register_b => sig_id_insn(7 downto 4),
               write_enable    => sig_wb_reg_write,
               write_register  => sig_wb_write_register,
               write_data      => sig_wb_write_data,
               write_enable_special => sig_id_write_enable_special,
               reg_2_write_data => sig_id_special_reg_data(15 downto 0),
               reg_3_write_data => sig_id_special_reg_data(31 downto 16),
               reg_4_write_data => sig_id_special_reg_data(47 downto 32),

               read_data_a     => sig_read_data_a,
               read_data_b     => sig_read_data_b );

    i_o_unit : io_unit port map (
        -- Inputs
        reset => reset,
        clock => clk,
        cpu_in => cpu_in,
        network_in => network_in,
        busy_in => sig_id_insn(3),
        attack_in => sig_id_insn(2),
        error_in => sig_id_insn(1),
        valid_in => sig_id_insn(0),
        status_reg_write_enable => sig_id_status_reg_write_enable,
        cpu_data_avail => send,
        net_data_avail => recv,

        -- Outputs
        busy_out => set_signal(3),
        attack_out => set_signal(2),
        error_out => set_signal(1),
        valid_out => set_signal(0),
        write_enable_special => sig_id_write_enable_special,
        reg_2 => sig_id_special_reg_data(15 downto 0),
        reg_3 => sig_id_special_reg_data(31 downto 16),
        reg_4 => sig_id_special_reg_data(47 downto 32)
    );
    -- EX: execute instruction

    -- signals through stages are set up using an N bit generic
    -- register.
    -- you first concatonate signals into a single in signal,
    -- then splice the out signal
    --
    -- WARNING: due to the downto nature of signals in this pipeline,
    -- SIGNALS MUST BE CONCATIONATED FROM HIGHEST TO LOWEST

    -- ID/EX register                 offset
    --      sig_reg_dst                 0
    --      sig_reg_write               1
    --      sig_alu_src                 2
    --      sig_alu_ctr                 4-3
    --      sig_mem_write               5
    --      sig_mem_to_reg              6
    --
    --      sig_read_data_a             22-7
    --      sig_read_data_b             38-23
    --      sig_id_insn(7 downto 4)     42-39    sig_ex_reg_1
    --      sig_id_insn(3 downto 0)     46-43    sig_ex_reg_2
    --      sig_sign_extended_offset    62-47
    --                                                          ^   concationate in this direction
    --      sig_id_insn                 78-63                   |
    --      sig_addr                    94-79


    -- set up in signal
    -- SIGNALS MUST BE CONCATIONATED FROM HIGHEST TO LOWEST
    sig_ex_in <=    sig_addr &
                    sig_id_insn &
                    sig_sign_extended_offset &
                    sig_id_insn(3 downto 0) &
                    sig_id_insn(7 downto 4) &
                    sig_read_data_b &
                    sig_read_data_a &
                    sig_mem_to_reg &
                    sig_mem_write &
                    sig_alu_ctr &
                    sig_alu_src &
                    sig_reg_write &
                    sig_reg_dst;

    -- set up out signal
    sig_ex_reg_dst              <= sig_ex_out(0);
    sig_ex_reg_write            <= sig_ex_out(1);
    sig_ex_alu_src              <= sig_ex_out(2);
    sig_ex_alu_ctr              <= sig_ex_out(4 downto 3);
    sig_ex_mem_write            <= sig_ex_out(5);
    sig_ex_mem_to_reg           <= sig_ex_out(6);
    sig_ex_read_data_a          <= sig_ex_out(22 downto 7);
    sig_ex_read_data_b          <= sig_ex_out(38 downto 23);
    sig_ex_reg_1                <= sig_ex_out(42 downto 39);
    sig_ex_reg_2                <= sig_ex_out(46 downto 43);
    sig_ex_sign_extended_offset <= sig_ex_out(62 downto 47);
    sig_ex_insn                 <= sig_ex_out(78 downto 63);
    sig_ex_addr                 <= sig_ex_out(94 downto 79);

    id_ex_reg : regne
    generic map( N => 95 )
    port map ( D        => sig_ex_in,
			   Resetn	=> reset,
			   clk    	=> clk,
			   Q 		=> sig_ex_out );

    mux_reg_dst : mux_2to1_4b
    port map ( mux_select => sig_ex_reg_dst,
               data_a     => sig_ex_reg_1,
               data_b     => sig_ex_reg_2,
               data_out   => sig_write_register );

    mux_alu_src : mux_2to1_16b
    port map ( mux_select => sig_ex_alu_src,
               data_a     => sig_ex_read_data_b,
               data_b     => sig_ex_sign_extended_offset,
               data_out   => sig_alu_src_b );


    -- forwarding logic
    frwd_unit : forwarding_unit
    Port map (mem_reg_write => sig_mem_reg_write,
              wb_reg_write  => sig_wb_reg_write,
              mem_rd        => sig_mem_write_register,
              wb_rd         => sig_mem_write_register,
              ex_rs         => sig_ex_reg_2,
              ex_rt         => sig_ex_reg_1,
              frwd_ctr_a    => sig_frwd_ctr_a,
              frwd_ctr_b    => sig_frwd_ctr_b);

    mux_alu_src_a : mux_4to1_16b
     port map ( mux_select => sig_frwd_ctr_a,
                data_a     => sig_ex_read_data_a,   -- no frwd  00
                data_b     => sig_ex_read_data_a,   -- no frwd  01
                data_c     => sig_mem_alu_ctr_out,  -- mem frwd 10
                data_d     => sig_wb_write_data,    -- wb fwrd  11
                data_out   => sig_frwd_a);

    mux_alu_src_b : mux_4to1_16b
     port map ( mux_select => sig_frwd_ctr_b,
                data_a     => sig_alu_src_b,        -- no frwd  00
                data_b     => sig_alu_src_b,        -- no frwd  01
                data_c     => sig_mem_alu_ctr_out,  -- mem frwd 10
                data_d     => sig_wb_write_data,    -- wb fwrd  11
                data_out   => sig_frwd_b);


    -- ALU not using forwarding logic
    alu: ALU_wrapper
      Port map (src_a   => sig_ex_read_data_a,
                src_b   => sig_alu_src_b,
                ctr     => sig_ex_alu_ctr,
                alu_out => sig_alu_ctr_out);


    -- MEM: memory access

    -- EX/MEM register                 offset
    --      sig_ex_mem_write              0
    --      sig_ex_mem_to_reg             1
    --      sig_write_register          5-2
    --      sig_alu_ctr_out             21-6
    --      sig_ex_read_data_b          37-22
    --      sig_ex_reg_write            38
    --      sig_ex_insn                 54-39   ^ concatonate this direction
    --      sig_ex_addr                 70-55

    -- set up in signals
    -- SIGNALS MUST BE CONCATIONATED FROM HIGHEST TO LOWEST
    sig_mem_in <=   sig_ex_addr &
                    sig_ex_insn &
                    sig_ex_reg_write &
                    sig_ex_read_data_b &
                    sig_alu_ctr_out &
                    sig_write_register &
                    sig_ex_mem_to_reg &
                    sig_ex_mem_write;

    -- set up out signals
    sig_mem_mem_write         <= sig_mem_out(0);
    sig_mem_mem_to_reg        <= sig_mem_out(1);
    sig_mem_write_register    <= sig_mem_out(5 downto 2);
    sig_mem_alu_ctr_out       <= sig_mem_out(21 downto 6);
    sig_mem_read_data_b       <= sig_mem_out(37 downto 22);
    sig_mem_reg_write         <= sig_mem_out(38);
    sig_mem_insn              <= sig_mem_out(54 downto 39);
    sig_mem_addr              <= sig_mem_out(70 downto 55);



    ex_mem_reg : regne
    generic map( N => 71 )
    port map ( D        => sig_mem_in,
			   Resetn	=> reset,
			   clk    	=> clk,
			   Q 		=> sig_mem_out );

    data_mem : data_memory
    port map ( reset        => reset,
               clk          => clk,
               write_enable => sig_mem_mem_write,
               write_data   => sig_mem_read_data_b,
               --addr_in      => sig_mem_alu_ctr_out(3 downto 0),
               addr_in      => sig_mem_addr(3 downto 0),
               data_out     => sig_data_mem_out );


    -- WB: write back

    -- MEM/WB register                offset
    --      sig_mem_mem_to_reg          0
    --      sig_data_mem_out            16-1
    --      sig_mem_alu_ctr_out         32-17
    --      sig_mem_write_register      36-33
    --      sig_mem_reg_write           37
    --      sig_mem_insn                53-38   ^ concatonate this direction

    -- set up wb in
    -- SIGNALS MUST BE CONCATIONATED FROM HIGHEST TO LOWEST
    sig_wb_in <=    sig_mem_insn &
                    sig_mem_reg_write &
                    sig_mem_write_register &
                    sig_mem_alu_ctr_out &
                    sig_data_mem_out &
                    sig_mem_mem_to_reg;

    -- set up wb out
    sig_wb_mem_to_reg        <= sig_wb_out(0);
    sig_wb_data_mem_out      <= sig_wb_out(16 downto 1);
    sig_wb_alu_ctr_out       <= sig_wb_out(32 downto 17);
    sig_wb_write_register    <= sig_wb_out(36 downto 33);
    sig_wb_reg_write         <= sig_wb_out(37);
    sig_wb_insn              <= sig_wb_out(53 downto 38);

    mem_wb_reg : regne
    generic map( N => 54 )
    port map ( D        => sig_wb_in,
			   Resetn	=> reset,
			   clk    	=> clk,
			   Q 		=> sig_wb_out );

    mux_mem_to_reg : mux_2to1_16b
    port map ( mux_select => sig_wb_mem_to_reg,
               data_a     => sig_wb_alu_ctr_out,
               data_b     => sig_wb_data_mem_out,
               data_out   => sig_wb_write_data );

end structural;
