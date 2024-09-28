library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proc is port
    (
        h : in std_logic;
        raz : in std_logic;
        mot_entree_sortie : inout std_logic_vector(31 downto 0)
    );
end entity;

architecture proc_archi of proc is
    signal h_fetch : std_logic;
    signal h_decode : std_logic;
    signal h_mem : std_logic;
    signal h_writeback : std_logic;
    signal instruction : std_logic_vector(31 downto 0);
    signal branch : std_logic;
    signal mem_read : std_logic;
    signal mem_to_reg : std_logic;
    signal alu_op : std_logic_vector(1 downto 0);
    signal mem_write : std_logic;
    signal alu_src : std_logic;
    signal reg_write : std_logic;
    signal reg_pc_out : std_logic_vector(8 downto 0);
    signal im_gen_out : std_logic_vector(31 downto 0);
    signal pc_src_mux_out : std_logic_vector(8 downto 0);
    signal add4_out : std_logic_vector(8 downto 0);
    signal add_out : std_logic_vector(8 downto 0);
    signal registers_read_data_1_out : std_logic_vector(31 downto 0);
    signal registers_read_data_2_out : std_logic_vector(31 downto 0);
    signal alu_control_input : std_logic_vector(3 downto 0);
    signal alu_result : std_logic_vector(31 downto 0);
    signal zero : std_logic;
    signal data_memory_out : std_logic_vector(31 downto 0);
    signal mem_to_reg_mux_out : std_logic_vector(31 downto 0);
    signal alu_src_mux_out : std_logic_vector(31 downto 0);
begin
    pll_inst : entity work.pll
    port map (
        h => h,
        h_fetch => h_fetch,
        h_decode => h_decode,
        h_mem => h_mem,
        h_writeback => h_writeback,
        raz => raz
    );

    reg_pc_inst : entity work.reg_pc
    port map (
                 entree => pc_src_mux_out,
                 sortie => reg_pc_out,
                 h => h_mem,
                 raz => raz
             );
    -- Le PC peut s'incrémenter après calcul de la branche éventuelle
    -- Et doit être disponible lors du fetch de l'instruction.
    -- D'où le h_mem.

    add4_inst : entity work.add
    port map (
                 e1 => reg_pc_out,
                 e2 => "000000100",
                 sortie => add4_out
             );

    add_inst : entity work.add
    port map (
                 e1 => reg_pc_out,
                 e2 => im_gen_out(8 downto 0),
                 sortie => add_out
             );

    instruction_memory_inst : entity work.instruction_memory
    port map (
                 adresse => reg_pc_out,
                 h => h_fetch,
                 instruction => instruction
             );
    registers_inst : entity work.registers
    port map (
                 adresse_read_1 => instruction(19 downto 15),
                 adresse_read_2 => instruction(24 downto 20),
                 adresse_write => instruction(11 downto 7),
                 ecriture => reg_write,
                 write_data => mem_to_reg_mux_out,
                 h_lec => h_decode,
                 h_ecr => h_writeback,
                 raz => raz,
                 read_data_1 => registers_read_data_1_out,
                 read_data_2 => registers_read_data_2_out
             );

    im_gen_inst : entity work.im_gen
    port map (
                 entree => instruction,
                 sortie => im_gen_out
             );

    alu_src_mux_inst : entity work.mux
    port map (
                 input_0 => registers_read_data_2_out,
                 input_1 => im_gen_out,
                 controle => alu_src,
                 sortie => alu_src_mux_out
             );

    control_inst: entity work.control
    port map (
                 opcode => instruction(6 downto 0),
                 branch => branch,
                 mem_read => mem_read,
                 mem_to_reg => mem_to_reg,
                 alu_op => alu_op,
                 mem_write => mem_write,
                 alu_src => alu_src,
                 reg_write => reg_write
             );

    alu_control_inst : entity work.alu_control
    port map (
                 alu_op => alu_op,
                 instruction_bit30 => instruction(30),
                 instruction_bit14_12 => instruction(14 downto 12),
                 alu_control_input => alu_control_input
             );

    alu_inst : entity work.alu
    port map (
                 alu_control_input => alu_control_input,
                 e1 => registers_read_data_1_out,
                 e2 => alu_src_mux_out,
                 result => alu_result,
                 zero => zero
             );

    pc_src_mux_inst : entity work.mux
    generic map (
        n => 9
    )
    port map (
                 input_0 => add4_out,
                 input_1 => add_out,
                 controle => branch and zero,
                 sortie => pc_src_mux_out
             );

    data_memory_inst : entity work.data_memory
    port map (
        adresse => alu_result(9 downto 0),
        h => h_mem,
        ecriture => mem_write,
        lecture => mem_read,
        write_data => registers_read_data_2_out,
        raz => raz,
        read_data => data_memory_out,
        mot_entree_sortie => mot_entree_sortie
    );

    mem_to_reg_mux_inst : entity work.mux
    port map (
                 input_0 => alu_result,
                 input_1 => data_memory_out,
                 controle => mem_to_reg,
                 sortie => mem_to_reg_mux_out
             );


end architecture;

