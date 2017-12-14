; the program computes the equation (100 * a + d + 5 - 75 * b) / (c - 5)
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10
    b db 8
    c db 15
    d dw 800

; our code starts here
segment code use32 class=code
    start:
        mov AL, [a]          ; AL = a = 10
        mov AH, 100          ; AH = 100
        mul AH               ; AL:AH <- AX = 100 * a = 1000
        
        mov BX, [d]          ; BX = d = 800
        add AX, BX           ; AX = AX + BX = 100a + d = 1800
        
        add AX, 5            ; AX = 100a + d + 5 = 1805
        mov BX, AX           ; BX = AX = 100a + d + 5 = 1805
        
        mov AL, [b]          ; AL = b = 8
        mov AH, 75           ; AH = 75
        mul AH               ; AL:AH <- AX = 75 * b = 600
        
        sub BX, AX           ; BX = BX - AX = 100a + d + 5 - 75 * b = 1205
        
        mov CL, [c]          ; CL = c = 15
        sub CL, 5            ; CL = c - 5 = 10
        
        mov AX, BX           ; AX = BX = 100a + d + 5 - 75 * b = 1205
        div CL               ; AX / CL <- AL = AX / CL = (100a + d + 5 - 75 * b) / (c - 5) = 1205 / 10 = 120
        

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
