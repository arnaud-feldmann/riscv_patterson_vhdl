library ieee;
use ieee.std_logic_1164.all;

entity reg_pc is
    port
    (
        entree : in std_logic_vector(8 downto 0);
        sortie : out std_logic_vector(8 downto 0);
        h : in std_logic;
        raz : in std_logic
    );
end entity;

architecture reg_pc_archi of reg_pc is
begin
    process (h, raz)
        variable sortie_temp : std_logic_vector(sortie'range);
    begin
        if raz then
            sortie_temp := (others => '0');
        elsif rising_edge(h) then
            sortie_temp := entree;
        end if;
        sortie <= sortie_temp;
    end process;

end architecture;

