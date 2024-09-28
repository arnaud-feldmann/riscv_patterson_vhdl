library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ram_init.all;

entity instruction_memory is
    port
    (
        adresse : in std_logic_vector(8 downto 0);
        h : in std_logic;
        instruction : out std_logic_vector(0 to 31)
    );
end entity;

architecture instruction_memory_archi of instruction_memory is
    constant instruction_memory_v : ram_t(0 to 127) := ram_init_const(0 to 127);
begin
    process (h)
    begin
        if rising_edge(h) then
            instruction <= instruction_memory_v(to_integer(unsigned(adresse(8 downto 2))));
            -- Ici les instructions sont toujours alignées donc on ignore les deux derniers bits d'adresse;
        end if;
    end process;
end architecture;

