.MACRO  mp_is_zero  inputAddress,  size

    MOV X1, \size
    SUB X1, X1, #8

    MOV X3, #0

    1:
    EOR X4, X1, #-8
    CBZ X4, 2f

        LDR X2, [\inputAddress,    X1]
        CMP X2, X3

        B.NE    2f
            
        SUB X1, X1, #8

    B   1b
    2:

.endmacro