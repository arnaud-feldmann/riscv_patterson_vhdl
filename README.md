[![Tests VHDL](https://github.com/arnaud-feldmann/riscv_patterson_vhdl/actions/workflows/makefile.yml/badge.svg)](https://github.com/arnaud-feldmann/riscv_patterson_vhdl/actions/workflows/makefile.yml)
    
Ce processeur est une implémentation pédagogique du processeur p280 de "Computer Organization And Design RISC-V Edition" écrite à but d'entraînement pour le M2 Seti. Il gère les instructions lw, sw, beq, et l'arithmétique R-type add/sub/and/or.

Un programme assembleur n'utilisant que ces instructions doit être mis dans program.s (comme l'exemple), et le make permet de le transformer en fichier d'initialisation au format .vhd.

Le .text et le .data font 128 mots de 4 octets chacun et sont placés consécutivement dans l'espace mémoire logique (c'est pourquoi le premier mot du segment data est à 512).
