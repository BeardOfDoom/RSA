// Assuming that size is bigger than the modulus's most significant bit and is divisible with 8.
.MACRO  mp_add  resultAddress,  addend1Address, addend2Address, size
    MOV X1, #8

    LDR X2, [\addend1Address]
    LDR X3, [\addend2Address]

    ADDS    X2, X2, X3

    STR X2, [\resultAddress]

    1:
    EOR X4, X1, \size
    CBZ X4, 2f

        LDR X2, [\addend1Address,   X1]
        LDR X3, [\addend2Address,   X1]
        ADCS    X2, X2, X3

        STR X2, [\resultAddress,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
.endmacro