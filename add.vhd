library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add is
    port
    (
        e1 : in std_logic_vector(8 downto 0);
        e2 : in std_logic_vector(8 downto 0);
        sortie : out std_logic_vector(8 downto 0)
    );
end entity;

architecture add_archi of add is
begin
    sortie <= std_logic_vector(unsigned(e1) + unsigned(e2));
end architecture;

