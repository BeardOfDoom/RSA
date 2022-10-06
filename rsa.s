.include "mp_mul.s"
.include "mp_sub_imm.s"
.include "mp_inverse.s"
.include "fp_exp.s"

.globl _main
.align 4
_main:

    // Put p into stack
    ADR X1, p1
    LDR X1, [X1]
    ADR X2, p2
    LDR X2, [X2]
    MOV X3, 0

    STP X3, X3, [SP,    -16]!
    STP X1, X2, [SP,    -16]!
    MOV X19,    SP  // p

    // Put q into stack
    ADR X1, q1
    LDR X1, [X1]
    ADR X2, q2
    LDR X2, [X2]
    MOV X3, 0

    STP X3, X3, [SP,    -16]!
    STP X1, X2, [SP,    -16]!
    MOV X20,    SP  // q

    // Setup memory on stack for n
    MOV X0, #0
    STP X0, X0, [SP,    -16]!
    STP X0, X0, [SP,    -16]!
    MOV X21,    SP

    // Compute n
    mp_mul  X21,    X19,    X20,    16

    // Setup memory on stack for p - 1
    MOV X0, #0
    STP X0, X0, [SP,    -16]!
    STP X0, X0, [SP,    -16]!
    MOV X22,    SP

    // Compute p - 1
    mp_sub_imm  X22,    X19,    1,  32

    // Setup memory on stack for q - 1
    MOV X0, #0
    STP X0, X0, [SP,    -16]!
    STP X0, X0, [SP,    -16]!
    MOV X23,    SP

    // Compute p - 1
    mp_sub_imm  X23,    X20,    1,  32

    // Setup memory on stack for fi(n)
    MOV X0, #0
    STP X0, X0, [SP,    -16]!
    STP X0, X0, [SP,    -16]!
    MOV X24,    SP

    // Compute fi(n)
    mp_mul  X24,    X22,    X23,    16

    // Put e into stack
    ADR X1, e1
    LDR X1, [X1]
    ADR X2, e2
    LDR X2, [X2]
    MOV X3, 0

    STP X3, X3, [SP,    -16]!
    STP X1, X2, [SP,    -16]!
    MOV X25,    SP  // e

    // Compute d with mp_inverse
    // X23 is d
    mp_inverse  X22,    X23,    X24,    X25,    32

    // Put d into field
    LDR X1, [X23,   8]
    MOV X2, 1
    LSL X2, X2, 63
    TST X1, X2
    B.EQ    1f

        mp_add  X23,    X23,    X24,    32

    1:

    // Setup a message
    MOV X1, 5
    MOV X2, 0
    STP X2, X2, [SP,    -16]!
    STP X1, X2, [SP,    -16]!
    MOV X26,    SP

    // Setup the memory for the cipher
    MOV X0, #0
    STP X0, X0, [SP,    -16]!
    STP X0, X0, [SP,    -16]!
    MOV X27,    SP

    // Encrypt
    fp_exp  X27,    X26,    x25,    X21,    32

    // Setup the memory for the decrypted message
    MOV X0, #0
    STP X0, X0, [SP,    -16]!
    STP X0, X0, [SP,    -16]!
    MOV X28,    SP

    // Decrypt
    fp_exp  X28,    X27,    x23,    X21,    32

    adr x0, Lstr
    bl  _printf

    mov     X0, #0
    mov     X16, #1
    svc     0

Lstr:
    .asciz "result: %ld %ld %ld %ld\n"

p1: .dword  0x8BD93D4C65C62AB9
p2: .dword  0x0

q1: .dword  0xD0813D2C9AB3DDA7
q2: .dword  0x0

e1: .dword  0x10001
e2: .dword  0x0