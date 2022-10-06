.MACRO  mp_sub_imm  resultAddress,  minuendAddress, subtrahend,  size
    MOV X1, #8

    LDR X2, [\minuendAddress]

    SUBS    X2, X2, \subtrahend

    STR X2, [\resultAddress]

    MOV X3, 0

    1:  
    EOR X4, X1, \size
    CBZ X4, 2f

        LDR X2, [\minuendAddress,   X1]
        SBCS    X2, X2, X3

        STR X2, [\resultAddress,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
.endmacro