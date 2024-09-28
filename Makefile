ram_init.vhd: program.s program_linker.ld make_ram_init.sh
	riscv64-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -T program_linker.ld -o program.o program.s
	riscv64-elf-objcopy -O binary program.o program.bin
	hexdump -v -e '1/4 "%08x\n"' program.bin > program.hex
	./make_ram_init.sh program.hex ram_init.vhd
	rm -f program.o program.bin

