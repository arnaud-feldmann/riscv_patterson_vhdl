library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
    port
    (
        adresse_read_1 : in std_logic_vector(4 downto 0);
        adresse_read_2 : in std_logic_vector(4 downto 0);
        adresse_write : in std_logic_vector(4 downto 0);
        ecriture  : in std_logic;
        write_data : in std_logic_vector(31 downto 0);
        h_lec : in std_logic;
        h_ecr : in std_logic;
        raz : in std_logic;
        read_data_1 : out std_logic_vector(31 downto 0);
        read_data_2 : out std_logic_vector(31 downto 0)
    );
end entity;

architecture registers_archi of registers is
    constant registers_size : integer := 2 ** adresse_read_1'length;
    type registers_t is array (0 to registers_size -1) of std_logic_vector(31 downto 0);
    signal registers_v : registers_t; 
begin

    process (h_lec)
    begin
        if rising_edge(h_lec) then
            read_data_1 <= registers_v(to_integer(unsigned(adresse_read_1)));
            read_data_2 <= registers_v(to_integer(unsigned(adresse_read_2)));
        end if;
    end process;

    process (h_ecr, raz)
    begin
        if raz then
            for i in 31 downto 0 loop
                registers_v(i) <= (others => '0');
            end loop;
        elsif rising_edge(h_ecr) and ecriture = '1' and adresse_write /= "00000" then
            registers_v(to_integer(unsigned(adresse_write))) <= write_data;
        end if;
    end process;

end architecture;

