library ieee;
use ieee.std_logic_1164.all;

entity alu_control is port
    (
        alu_op : in std_logic_vector(1 downto 0);
        instruction_bit30 : in std_logic;
        instruction_bit14_12 : in std_logic_vector(14 downto 12);
        alu_control_input : out std_logic_vector(3 downto 0)
    );
end entity;

architecture alu_control_archi of alu_control is
begin
    alu_control_input <=
   "0110" when alu_op = "01" or (alu_op = "10" and instruction_bit30 = '1' and instruction_bit14_12 = "000") else -- beq ou sub
   "0000" when alu_op = "10" and instruction_bit30 = '0' and instruction_bit14_12 = "111" else -- beq ou sub
   "0001" when alu_op = "10" and instruction_bit30 = '0' and instruction_bit14_12 = "110" else -- or
   "0010"; -- lw, sw ou add
end architecture;
