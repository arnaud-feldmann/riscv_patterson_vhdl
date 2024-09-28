.text 
	lw x10, 512(x0) # adresse de x = 128 * 4 = 512
	lw x5, 516(x0) # adresse de y = 129 * 4 = 516
	add x10, x10, x5
    sw x10, 1020(x0) # le dernier mot, à savoir d'adresse 255*4, est en entrée/sortie
end:
    beq x0, x0, end

.data 
x:      .word 42
y:      .word 25
