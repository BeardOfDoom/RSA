.MACRO  mp_add  resultAddress,  addend1Address, addend2Address, modulusAddress, size
    MOV X1, #64

    LDR X2, [\addend1Address]
    LDR X3, [\addend2Address]

    ADDS    X2, X2, X3

    STR X2, [\resultAddress]

    1:  
    TEQ X1, \size
    B.EQ    2f

        LDR X2, [\addend1Address,   X1]
        LDR X3, [\addend2Address,   X1]
        ADCS    X2, X2, X3

        STR X2, [\resultAddress,    X1] // Could optimize if not stored yet
            
        ADD X1, #64

    B   1b
    2:
.endmacro