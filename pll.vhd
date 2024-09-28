library ieee;
use ieee.std_logic_1164.all;

entity pll is
    port
    (
        h : in std_logic;
        h_fetch : out std_logic;
        h_decode : out std_logic;
        h_mem: out std_logic;
        h_writeback : out std_logic;
        raz : in std_logic
    );
end entity;

architecture pll_archi of pll is
    type etat_t is (FETCH, DECODE, EXECUTE, MEM, WRITEBACK, RESET_A, RESET_B);
    -- On a besoin des lectures d'adresses pour lire la mémoire sur un load ou l'écrire sur un store.
    -- On a besoin de la lecture de mémoire pour écrire un registre sur un load.
    -- L'écriture de registre doit être accomplie avant l'instruction suivante
    -- On a donc besoin de 4 horloges. On s'inspire de la classique pipeline donc, sauf que l'exécution est asynchrone donc n'a pas besoin d'horloge en sortie.
    -- On ajoute deux états reset pour que FETCH se déclare bien de manière synchrone en cas de reset, après avoir
    -- Bien attendu une horloge pour que tout soit propre.
    signal present, futur : etat_t;
begin

    with present select futur <=
    DECODE when FETCH,
    EXECUTE when DECODE,
    MEM when EXECUTE,
    WRITEBACK when MEM,
    FETCH when WRITEBACK,
    RESET_B when RESET_A,
    FETCH when RESET_B;

    process (h, raz) is
    begin
        if raz then
            present <= RESET_A;
        elsif rising_edge(h)
        then
            present <= futur;
        end if;
    end process;

    process (present) is
    begin
        h_fetch <= '0';
        h_decode <= '0';
        h_mem <= '0';
        h_writeback <= '0';
        case present is
            when FETCH =>  h_fetch <= '1';
            when DECODE =>  h_decode <= '1';
            when EXECUTE | RESET_A | RESET_B => null;
            when MEM =>  h_mem <= '1';
            when WRITEBACK =>  h_writeback <= '1';
        end case;
    end process;

end architecture;

