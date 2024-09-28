.text 
lw x10, 512(x0) # x10 := x* = 42
lw x5, 516(x0) # x5 :=  y* = 25
lw x6, 520(x0) # x6 := z* = 4
add x10, x10, x5 # x10 := x10+x5 = 42+25 = 67
lw x6, 520(x6) # x6 := (520+x6)* = (520+4)* = n* = 2
lw x5, 520(x0) # x5 := z* = 4
loop:
sub x10, x10, x5 # x10 = x10-x5 (= 67-4 = 63 puis = 63-2 = 61)
sub x5, x5, x6 # x5 = x5-x6 (= 4-2 = 2 puis = 2-2 = 0)
beq x5, x0, suite # déclenché la deuxième fois
beq x0, x0, loop
suite:
lw x6, 520(x0) # x6 := z* = 4
lw x0, 520(x0) # doit laisser x0 fixe car x0 est cablé à 0
lw x7, 524(x0) # x7 := z* = 2
add x8, x6, x7 # x8 := x6+x7 = 6
and x9, x10, x8 # x9 := x10 & x8 = 61 & 6 = 4
or x11, x10, x8 # x11 := x10 | x8 = 61 | 6 = 63
sub x12, x11, x9 # x12 := x11-x9 = 63-4 = 59
add x12, x12, x12 # x12 := x12+x12 = 59+59 = 118
sub x10, x12, x10 # x10 := x12-x10 = 118-61 = 57
sw x10, 1020(x0) # (1020)* := x10 = 61 (1020 est l'adresse d'entrée/sortie)
end:
beq x0, x0, end

.data 
x:      .word 42
y:      .word 25
z:      .word 4
n:      .word 2
