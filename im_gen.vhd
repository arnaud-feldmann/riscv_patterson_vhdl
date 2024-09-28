library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity im_gen is
    port
    (
        entree : in std_logic_vector(31 downto 0);
        sortie : out std_logic_vector(31 downto 0)
    );
end entity;

architecture im_gen_archi of im_gen is
begin
    with entree(6 downto 4) select sortie <=
    (31 downto 11 => entree(31)) & entree(30 downto 20) when "000" , -- lw.
    (31 downto 11 => entree(31)) & entree(30 downto 25) & entree(11 downto 7) when "010", -- sw 
    (31 downto 12 => entree(31), 11 => entree(7)) & entree(30 downto 25) & entree(11 downto 8) & "0" when "110", -- beq
    (others => '0') when others; -- R-type (pas d'imm.)
end architecture;

