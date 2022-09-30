// Assuming that size is bigger than the modulus's most significant bit and is divisible with 64.
.MACRO  mp_sub  resultAddress,  minuendAddress, subtrahendAddress,  size
    MOV X1, #64

    LDR X2, [\minuendAddress]
    LDR X3, [\subtrahendAddress]

    SUBS    X2, X2, X3

    STR X2, [\resultAddress]

    1:  
    TEQ X1, \size
    B.EQ    2f

        LDR X2, [\minuendAddress,   X1]
        LDR X3, [\subtrahendAddress,   X1]
        SBCS    X2, X2, X3

        STR X2, [\resultAddress,    X1]
            
        ADD X1, #64

    B   1b
    2:
.endmacro