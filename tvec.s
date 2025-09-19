.macro push r
    addi sp, sp, -4
    sw \r, 0(sp)
.endm
.macro push_sp
    sw sp, -4(sp)
    addi sp, sp, -4
.endm

.macro pop r
    lw \r, 0(sp)
    addi sp, sp, 4
.endm
.macro pop_sp
    lw sp, 0(sp)
.endm

push_sp
push x1
push x2
push x3
push x4
push x5
push x6
push x7
push x8
push x9
push x10
push x11
push x12
push x13
push x14
push x15
push x16
push x17
push x18
push x19
push x20
push x21
push x22
push x23
push x24
push x25
push x26
push x27
push x28
push x29
push x30
push x31

mv a1, sp
call trap_handler

pop x31
pop x30
pop x29
pop x28
pop x27
pop x26
pop x25
pop x24
pop x23
pop x22
pop x21
pop x20
pop x19
pop x18
pop x17
pop x16
pop x15
pop x14
pop x13
pop x12
pop x11
pop x10
pop x9
pop x8
pop x7
pop x6
pop x5
pop x4
pop x3
pop x2
pop x1
pop_sp
sret