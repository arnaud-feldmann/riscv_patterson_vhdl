library ieee;
use ieee.std_logic_1164.all;

entity de10_lite is port
    (
        key : in std_logic_vector(0 downto 0);
        adc_clk_10 : in std_logic;
        ledr : out std_logic_vector(9 downto 0)
    );
end entity;

architecture de10_lite_archi of de10_lite is
    signal mot_entree_sortie : std_logic_vector(31 downto 0);
begin
    ledr <= mot_entree_sortie(9 downto 0);
    proc_inst : entity work.proc
    port map (
        h => adc_clk_10,
        raz => not key(0),
        mot_entree_sortie => mot_entree_sortie 
    );
end architecture;

