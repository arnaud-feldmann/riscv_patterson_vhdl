library ieee;
use ieee.std_logic_1164.all;
use std.env.finish;

entity proc_test is
    end entity;

architecture proc_test_arch of proc_test is
    signal h : std_logic;
    signal raz : std_logic;
    signal mot_entree_sortie : std_logic_vector(31 downto 0);
begin
    proc_inst : entity work.proc
    port map
    (
        h => h,
        raz => raz,
        mot_entree_sortie => mot_entree_sortie 
    );

    process
    begin
        h <= '0';
        wait for 50 ns;
        h <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        wait for 2 ns;
        raz <= '1';
        wait until h = '1';
        wait for 45 ns;
        raz <= '0';
        for i in 120 downto 0 loop
            wait until h = '1';
        end loop;
        assert mot_entree_sortie = (31 downto 6 => '0') & "111001" report "Le résultat du programme est 57." severity error;
        for i in 300 downto 0 loop
            wait until h = '1';
        end loop;
        assert mot_entree_sortie = (31 downto 6 => '0') & "111001" report "Le programme finit par une boucle infinie donc doit rester sur 57." severity error;
        finish;
    end process;

end architecture;

