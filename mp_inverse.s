.include "mp_lsr_1.s"
.ifndef _mp_add
    _mp_add:
    .include "mp_add.s"
.endif
.ifndef _mp_sub
    _mp_sub:
    .include "mp_sub.s"
.endif
.include "mp_cmp.s"
.include "mp_is_zero.s"

.MACRO mp_inverse result1Address,  result2Address, xAddress,   yAddress,   size
/* 
INPUT: two positive integers x and y.
OUTPUT: integers a, b, and v such that ax + by = v, where v = gcd(x, y).
    1. g←1.
    2. While x and y are both even, do the following: x←x/2, y←y/2, g←2g.
    3. u←x, v←y, A←1, B←0, C←0, D←1.
    4. While u is even do the following:
        4.1 u←u/2.
        4.2 If A ≡ B ≡ 0 (mod 2) then A←A/2, B←B/2;
            otherwise, A←(A + y)/2, B←(B − x)/2.
    5. While v is even do the following:
        5.1 v←v/2.
        5.2 If C ≡ D ≡ 0 (mod 2) then C←C/2, D←D/2;
            otherwise, C←(C + y)/2, D←(D − x)/2.
    6. If u≥v then u←u−v, A←A−C,B←B−D;
        otherwise,v←v−u, C←C−A, D←D−B.
    7. If u = 0, then a←C, b←D, and return(a, b, g · v);
        otherwise, go to step 4. 
*/

    MOV X1, \result1Address
    MOV X2, \result2Address
    MOV X3, \xAddress
    MOV X4, \yAddress
    MOV X5, \size

    STP X19,    X20,    [SP,    #-16]!
    STP X21,    X22,    [SP,    #-16]!
    STP X23,    X24,    [SP,    #-16]!
    STP X25,    X26,    [SP,    #-16]!
    STR X27,    [SP,    #-16]!

    MOV X19,    X1  // C
    MOV X20,    X2  // D
    MOV X21,    X3  // x
    MOV X22,    X4  // y
    MOV X23,    X5  // size

    // Setup C
    MOV X1, #0
    MOV X0, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        STR X0, [X19,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:

    // Setup D
    MOV X1, #0
    MOV X0, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        STR X0, [X20,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
    MOV X0, #1
    STR X0, [X20]

    // Copy x to u
    SUB SP, SP, X23
    MOV X1, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        LDR X2, [X21,   X1]

        STR X2, [SP,   X1]
            
        ADD X1, X1, #8

    B   1b
    2:
    MOV X24,    SP  // u

    // Copy y to v
    SUB SP, SP, X23
    MOV X1, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        LDR X2, [X22,   X1]

        STR X2, [SP,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
    MOV X25,    SP  // v

    SUB SP, SP, X23
    MOV X1, #0
    MOV X0, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        STR X0, [SP,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
    MOV X26,    SP  // A
    MOV X0, #1
    STR X0,    [X26]

    SUB SP, SP, X23
    MOV X1, #0
    MOV X0, #0
    1:
    EOR X4, X1, X23
    CBZ X4, 2f

        STR X0, [SP,    X1]
            
        ADD X1, X1, #8

    B   1b
    2:
    MOV X27,    SP  // B

    /*4. While u is even do the following:
        4.1 u←u/2.
        4.2 If A ≡ B ≡ 0 (mod 2) then A←A/2, B←B/2;
            otherwise, A←(A + y)/2, B←(B − x)/2.*/

    4:

    LDR X1, [X24]
    TST X1, #1
    B.NE    5f

        // u←u/2
        mp_lsr_1    X24,    X23

        LDR X1, [X26]
        TST X1, #1
        B.NE    43f

            LDR X1, [X27]
            TST X1, #1
            B.NE    43f

                // A←A/2
                mp_lsr_1    X26,    X23
                // B←B/2
                mp_lsr_1    X27,    X23

        B   4b

        43:

            // A←(A + y)/2
            mp_add  X26,    X26,    X22,    X23
            mp_lsr_1    X26,    X23
            // B←(B − x)/2
            mp_sub  X27,    X27,    X21,    X23
            mp_lsr_1    X27,    X23 // TODO is it ok? negativ is lehet

        B   4b


    /*5. While v is even do the following:
        5.1 v←v/2.
        5.2 If C ≡ D ≡ 0 (mod 2) then C←C/2, D←D/2;
            otherwise, C←(C + y)/2, D←(D − x)/2.*/
    5:

    LDR X1, [X25]
    TST X1, #1
    B.NE    6f

        // v←v/2
        mp_lsr_1    X25,    X23

        LDR X1, [X19]
        TST X1, #1
        B.NE    53f

            LDR X1, [X20]
            TST X1, #1
            B.NE    53f

                // C←C/2
                mp_lsr_1    X19,    X23
                // D←D/2
                mp_lsr_1    X20,    X23

        B   5b

        53:

            // C←(C + y)/2
            mp_add  X19,    X19,    X22,    X23
            mp_lsr_1    X19,    X23
            // D←(D − x)/2
            mp_sub  X20,    X20,    X21,    X23
            mp_lsr_1    X20,    X23 // TODO is it ok? negativ is lehet

        B   5b
    

    /*6. If u≥v then u←u−v, A←A−C,B←B−D;
        otherwise,v←v−u, C←C−A, D←D−B.*/
    6:
    
    mp_cmp  X24,    X25,    X23
    B.LO    62f

        mp_sub  X24,    X24,    X25,    X23
        mp_sub  X26,    X26,    X19,    X23
        mp_sub  X27,    X27,    X20,    X23

    B   7f

    62:

        mp_sub  X25,    X25,    X24,    X23
        mp_sub  X19,    X19,    X26,    X23
        mp_sub  X20,    X20,    X27,    X23


    /*7. If u = 0, then a←C, b←D, and return(a, b, g · v);
        otherwise, go to step 4. */
    7:

        mp_is_zero  X24,    X23
        B.NE    4b

    ADD SP, SP, X23
    ADD SP, SP, X23
    ADD SP, SP, X23
    ADD SP, SP, X23
    LDR X27,    [SP],   #16
    LDP X25,    X26,    [SP],   #16
    LDP X23,    X24,    [SP],   #16
    LDP X21,    X22,    [SP],   #16
    LDP X19,    X20,    [SP],   #16
.endmacro