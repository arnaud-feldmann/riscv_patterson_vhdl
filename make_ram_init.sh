#!/bin/bash

fichier_hex="$1"
fichier_vhdl="$2"

echo "library ieee;" > "$fichier_vhdl"
echo "use ieee.std_logic_1164.all;" >> "$fichier_vhdl"
echo "use ieee.numeric_std.all;" >> "$fichier_vhdl"
echo "package ram_init is" >> "$fichier_vhdl"
echo "type ram_t is array (natural range <>) of std_logic_vector(31 downto 0);" >> "$fichier_vhdl"
echo "constant ram_init_const : ram_t(0 to 255) := (" >> "$fichier_vhdl"

mapfile -t lignes < "$fichier_hex"
for i in "${!lignes[@]}"; do
    if [ "$i" -ne 0 ]; then
        echo "," >> "$fichier_vhdl"
    fi
    echo "x\"${lignes[$i]}\"" >> "$fichier_vhdl"
done

echo ");" >> "$fichier_vhdl"
echo "end package;" >> "$fichier_vhdl"

