.MACRO  mp_cmp  input1Address,  input2Address,  size

    MOV X1, \size
    SUB X1, X1, #8

    101:
    EOR X4, X1, #-8
    CBZ X4, 102f

        LDR X2, [\input1Address,    X1]
        LDR X3, [\input2Address,    X1]

        CMP X2, X3

        B.NE    102f
            
        SUB X1, X1, #8

    B   101b
    102:

.endmacro