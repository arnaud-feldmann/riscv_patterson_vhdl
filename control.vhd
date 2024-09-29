library ieee;
use ieee.std_logic_1164.all;

entity control is port
    (
        opcode : in std_logic_vector(6 downto 0);
        branch : out std_logic;
        mem_read : out std_logic;
        mem_to_reg : out std_logic;
        alu_op : out std_logic_vector(1 downto 0);
        mem_write : out std_logic;
        alu_src : out std_logic;
        reg_write : out std_logic
    );
end entity;

architecture control_archi of control is
begin
    branch <= '1' when opcode(6 downto 5) = "11" else '0';
    mem_read <= '1' when opcode(6 downto 4) = "000" else '0';
    mem_to_reg <= '1' when opcode(6 downto 4) = "000" else '0';
    with opcode(6 downto 4) select alu_op <=
    "01" when "110", -- beq
    "10" when "011", -- add, sub, and, or
    "00" when others; -- lw ou sw
    mem_write <= '1' when opcode(6 downto 4) = "010" else '0'; -- sw
    alu_src <= '1' when opcode(6 downto 4) = "000" or opcode(6 downto 4) = "010" else '0'; -- lw ou sw
    reg_write <= '1' when opcode(6 downto 4) = "000" or opcode(6 downto 4) = "011" else '0'; -- lw ou add/sub/and/or
end architecture;

