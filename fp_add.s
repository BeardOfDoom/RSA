// Assuming that size is bigger than the modulus's most significant bit and is divisible with 8.
.ifndef _mp_add
    _mp_add:
    .include "mp_add.s"
.endif

.ifndef _mp_sub
    _mp_sub:
    .include "mp_sub.s"
.endif

.MACRO  fp_add  resultAddress,  addend1Address, addend2Address, modulusAddress, size

    mp_add  \resultAddress, \addend1Address,    \addend2Address,    \size

    // Sub modulus

    mp_sub  \resultAddress, \resultAddress, \modulusAddress,    \size

    // Add back 0 if sub was necessary, mask if it was unnecessary
    MOV X4, #0
    SBC X4, X4, X4

    MOV X1, #8
    LDR X2, [\resultAddress]
    LDR X3, [\modulusAddress]

    AND X3, X3, X4

    ADDS    X2, X2, X3

    STR X2, [\resultAddress]

    1:  
    EOR X5, X1, \size
    CBZ X5, 2f

        LDR X2, [\resultAddress,   X1]
        LDR X3, [\modulusAddress,   X1]

        AND X3, X3, X4
        ADCS    X2, X2, X3

        STR X2, [\resultAddress,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
.endmacro