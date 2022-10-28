.data
buffer: .space 16
num0:   .word  1
A: 3
B: 2

.text
main:
    li t0, 2
    li t1, 1
  
    add t1, t1, t1
    
    ERROR_ER:
	beq t0, t1, EFECTIVO_R
    
    and t3, t4, t1
    addi t4, t4, -1      # decrementa infinitamente t4
    beq  x0, x0, ERROR_ER

    EFECTIVO_R:
    add t1, t1, t1
    beq t0, t1, NO_EFECTIVO_R
    

    
    lw t0, x0(A)
    beq t0, t1, EFECTIVO_L
    addi t4, t4, -1      # decrementa infinitamente t4
    beq  x0, x0, ERROR_EL

    EFECTIVO_L:
    lw t0, x0(B)
    beq t0, t1, NO_EFECTIVO_L
    
    jalr zero, 0(ra)   # retorno al llamado
    


    NO_EFECTIVO_L: addi t4, t4, -1      # decrementa infinitamente t4
    beq  x0, x0, NO_EFECTIVO_L
    
    NO_EFECTIVO_R: addi t4, t4, -1      # decrementa infinitamente t4
    beq  x0, x0, NO_EFECTIVO_R