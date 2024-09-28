library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ram_init.all;

entity data_memory is
    port
    (
        adresse : in std_logic_vector(9 downto 0);
        h : in std_logic;
        ecriture : in std_logic;
        lecture : in std_logic;
        write_data : in std_logic_vector(31 downto 0);
        raz : in std_logic;
        read_data : out std_logic_vector(31 downto 0);
        mot_entree_sortie : inout std_logic_vector(31 downto 0)
    );
end entity;

architecture data_memory_archi of data_memory is
    constant data_memory_init : ram_t := ram_init_const(128 to 255);
begin
    process (h, raz)
        variable data_memory_v : ram_t(0 to 127) := data_memory_init; 
    begin
        if raz = '1' then
            data_memory_v := data_memory_init;
        elsif rising_edge(h) then
            if ecriture = '1' then
                data_memory_v(to_integer(unsigned(adresse(9 downto 2))) - 128) := write_data;
            elsif lecture = '1' then
                read_data <= data_memory_v(to_integer(unsigned(adresse(9 downto 2))) - 128);
            else read_data <= (others => '0');
            -- Ici les datas sont toujours alignées donc on ignore les deux derniers bits d'adresse;
            end if;
            mot_entree_sortie <= data_memory_v(127);
        end if;
    end process;
end architecture;

