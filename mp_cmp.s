.MACRO  mp_cmp  input1Address,  input2Address,  size

    MOV X1, \size
    SUB X1, X1, #8

    1:
    EOR X4, X1, #-8
    CBZ X4, 2f

        LDR X2, [\input1Address,    X1]
        LDR X3, [\input2Address,    X1]

        CMP X2, X3

        B.NE    2f
            
        SUB X1, X1, #8

    B   1b
    2:

.endmacro