// Assuming the multiplier and multiplicand is size/2 long at most.
.MACRO  mp_mul  resultAddress,  multiplicandAddress,    multiplierAddress,  size

MOV X1, \resultAddress
MOV X2, \multiplicandAddress
MOV X3, \multiplierAddress
MOV X4, \size

STP X19,    X20,    [SP,    -16]!
STP X21,    X22,    [SP,    -16]!

MOV X19,    X1  // Result
MOV X20,    X2  // Multiplicand
MOV X21,    X3  // Multiplier
MOV X22,    X4  // Size

// Divide Size with 2
LSR X22,    X22,    #1

// Setup Result
    MOV X4, #0
    MOV X5, #0
    1:
    EOR X1, X4, X22
    CBZ X1, 2f

        STR X5, [X19,    X4]
            
        ADD X4, X4, #8

    B   1b
    2:

MOV X4, 0   // Iterator for multiplier
MOV X5, 0   // Iterator for multiplicand

1:  
    EOR X1, X4, X22
    CBZ X1, 2f

        LDR X6, [X21,   X4]

        3:
        EOR X1, X5, X22
        CBZ X1, 4f

            LDR X7, [X20,   X4]

            MUL X8, X7, X6
            UMULH   X7, X7, X6

            ADD X9, X4, X5
            LDR X10,    [X19,   X9]
            ADDS    X10, X10, X8
            STR X10,    [X19,   X9]

            ADD X9, X9, 8
            LDR X10,    [X19,   X9]
            ADC    X10, X10, X7
            STR X10,    [X19,   X9]

        ADD X5, X5, #8

        B   3b
        4:
            
        ADD X4, X4, #8

    B   1b
    2:

    LDP X21,    X22,    [SP],   16
    LDP X20,    X19,    [SP],   16

.endmacro