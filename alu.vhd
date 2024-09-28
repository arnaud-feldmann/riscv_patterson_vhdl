library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is port
    (
        alu_control_input : in std_logic_vector(3 downto 0);
        e1 : in std_logic_vector(31 downto 0);
        e2 : in std_logic_vector(31 downto 0);
        result : out std_logic_vector(31 downto 0);
        zero : out std_logic
    );
end entity;

architecture alu_archi of alu is
begin
    with alu_control_input select result <=
    std_logic_vector(unsigned(e1) + unsigned(e2)) when "0010",
    std_logic_vector(unsigned(e1) and unsigned(e2)) when "0000",
    std_logic_vector(unsigned(e1) or unsigned(e2)) when "0001",
    std_logic_vector(unsigned(e1) - unsigned(e2)) when "0110",
    (31 downto 0 => '0') when others;
    zero <= '1' when result = (31 downto 0 => '0') else '0';
end architecture;
