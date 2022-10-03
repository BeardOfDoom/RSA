//Assuming size is bigger than 8

.align 4

.MACRO  mp_lsr_1  inputAddress, size

    MOV X1, \size
    SUB X1, X1, #8

    LDR X2, [\inputAddress,    X1]
    
    TST X2, #1
    LSR X2, X2, #1

    STR X2, [\inputAddress,   X1]

    SUB X1, X1, #8

    1:
    EOR X4, X1, #-8
    CBZ X4, 2f

        B.EQ    3f

            LDR X2, [\inputAddress,    X1]

            TST X2, #1
            LSR X2, X2, #1

            ORR X2, X2, #0x8000000000000000

            STR X2, [\inputAddress,   X1]

            SUB X1, X1, #8

        B   1b
        3:

            LDR X2, [\inputAddress,    X1]

            TST X2, #1
            LSR X2, X2, #1

            STR X2, [\inputAddress,   X1]

            SUB X1, X1, #8

    B   1b
    2:

.endmacro