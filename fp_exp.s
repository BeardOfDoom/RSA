.include "fp_mul.s"
.align 4

.MACRO fp_exp   resultAddress,  baseAddress,    exponentAddress,    modulusAddress, size

    MOV X1, \resultAddress
    MOV X2, \baseAddress
    MOV X3, \exponentAddress
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

    MOV X0, #1
    STR X0, [X19]

    // Create a copy of the base
    SUB SP, SP, X23
    MOV X1, #0
    11:
    EOR X4, X1, X23
    CBZ X4, 12f

        LDR X2, [X20,   X1]

        STR X2, [SP,   X1]
            
        ADD X1, X1, #8

    B   11b
    12:

    MOV X24,    SP
    
    // Start the fast modular exponentiation
    MOV X26, #0

    13:
    EOR X4, X26, X23
    CBZ X4, 14f

        LDR X25,    [X21,   X26]
        MOV X27, #0

        15:
        TST X25, #1
        LSR X25, X25, #1
        B.EQ    16f

            // Multiply the current base
            fp_mul  X19,    X19,    X24,    X22,    X23

        16:

        // Square the base
        fp_mul  X24,    X24,    X24,    X22,    X23

        ADD X27, X27, #1

        CMP X27, #64
        B.NE    15b

        ADD X26, X26, #8
    
    B   13b
    14:

    ADD SP, SP, X23
    LDR X27,    [SP],   #16
    LDP X25,    X26,    [SP],   #16
    LDP X23,    X24,    [SP],   #16
    LDP X21,    X22,    [SP],   #16
    LDP X19,    X20,    [SP],   #16

.endmacro

testStrExp1:
    .asciz "Exp1 %ld %ld\n"

    testStrExp2:
    .asciz "Exp2 %ld %ld\n"

    testStrExp3:
    .asciz "Exp3 %ld %ld\n"

    testStrExp4:
    .asciz "Exp4 %ld %ld\n"