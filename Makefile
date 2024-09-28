TESTS=proc_test

DEPENDENCIES_proc_test=ram_init.vhd add.vhd alu_control.vhd alu.vhd control.vhd data_memory.vhd instruction_memory.vhd im_gen.vhd mux.vhd pll.vhd registers.vhd reg_pc.vhd proc.vhd proc_test.vhd

GHDLFLAGS= --std=08 --workdir=work

all: $(TESTS)

%.compiled: %.vhd
	mkdir -p work
	ghdl -a $(GHDLFLAGS) --workdir=work $<
	touch $@

define test_template =
$(1): $$(addsuffix .compiled, $$(basename $$(DEPENDENCIES_$(1))))
	ghdl -e $(GHDLFLAGS) $(1)
	$$(foreach file,$$(DEPENDENCIES_$(1)),touch $$(basename $$(file));)
endef

$(foreach test,$(TESTS),$(eval $(call test_template,$(test))))

test: $(TESTS)
	@for test in $(TESTS); do \
		echo -ne "$$test : " && \
		ghdl -r $(GHDLFLAGS) $$test; \
		done

%.ghw: %.compiled
	ghdl -r $(GHDLFLAGS) $(basename $<) --wave=$@

%.vcd: %.compiled
	ghdl -r $(GHDLFLAGS) $(basename $<) --vcd=$@

vcd: $(addsuffix .vcd, $(TESTS))

ghw: $(addsuffix .ghw, $(TESTS))

clean:
	ghdl --clean $(GHDLFLAGS) 2>/dev/null
	rm -rf work
	rm -f $(TESTS)
	rm -f $(addsuffix .vcd, $(TESTS))
	rm -f $(addsuffix .ghw, $(TESTS))
	rm -f $(foreach test,$(TESTS),$(addsuffix .compiled, $(basename $(DEPENDENCIES_$(test)))))
	rm -f ram_init.vhd program.hex

ram_init.vhd: program.s program_linker.ld make_ram_init.sh
	$(shell command -v riscv64-elf-gcc || command -v riscv64-unknown-elf-gcc) -march=rv32i -mabi=ilp32 -nostdlib -T program_linker.ld -o program.o program.s
	$(shell command -v riscv64-elf-objcopy || command -v riscv64-unknown-elf-objcopy) -O binary program.o program.bin
	hexdump -v -e '1/4 "%08x\n"' program.bin > program.hex
	./make_ram_init.sh program.hex ram_init.vhd
	rm -f program.o program.bin
