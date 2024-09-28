library ieee;
use ieee.std_logic_1164.all;

entity mux is
    generic
    (
        n : integer := 32
    );
    port
    (
        input_0 : in std_logic_vector(n - 1 downto 0);
        input_1 : in std_logic_vector(n - 1 downto 0);
        controle : in std_logic;
        sortie : out std_logic_vector(n - 1 downto 0)
    );
end entity;

architecture mux_archi of mux is
begin
    sortie <= input_1 when controle else input_0;
end architecture;

