.include "fp_add.s"

// Implementing the double-and-add method for modular multiplication.
.MACRO  fp_mul  resultAddress,  multiplicandAddress, multiplierAddress, modulusAddress, size

    MOV X1, \resultAddress
    MOV X2, \multiplicandAddress
    MOV X3, \multiplierAddress
    MOV X4, \modulusAddress
    MOV X5, \size

    STP X19,    X20,    [SP,    #-16]!
    STP X21,    X22,    [SP,    #-16]!
    STP X23,    X24,    [SP,    #-16]!
    STP X25,    X26,    [SP,    #-16]!
    STR X27,    [SP,    #-16]!

    MOV X19,    X1
    MOV X20,    X2
    MOV X21,    X3
    MOV X22,    X4
    MOV X23,    X5

    // Create a copy of the multiplicand
    SUB SP, SP, X23
    MOV X1, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        LDR X2, [X20,   X1]

        STR X2, [SP,   X1]
            
        ADD X1, X1, #8

    B   1b
    2:

    MOV X24,    SP
    
    // Start the double-and-add method
    MOV X26, #0

    3:
    EOR X4, X26, X23
    CBZ X4, 4f

        LDR X25,    [X21,   X26]
        MOV X27, #0

        5:
        TST X25, #1
        LSR X25, X25, #1
        B.EQ    6f

            // Add the current base
            fp_add  X19,    X19,    X24,    X22,    X23

        6:

        // Double the base
        fp_add  X24,    X24,    X24,    X22,    X23

        ADD X27, X27, #1

        CMP X27, #64
        B.NE    5b

        ADD X26, X26, #8

    B   3b
    4:

    ADD SP, SP, X23
    LDR X27,    [SP],   #16
    LDP X25,    X26,    [SP],   #16
    LDP X23,    X24,    [SP],   #16
    LDP X21,    X22,    [SP],   #16
    LDP X19,    X20,    [SP],   #16
.endmacro


testStr:
    .asciz "test %ld %ld\n"