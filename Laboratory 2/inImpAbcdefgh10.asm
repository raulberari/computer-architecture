; the program computes the equation a * d + b * c
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10
    b db 15
    c db 5
    d db 8

; our code starts here
segment code use32 class=code
    start:
        mov AL, [a]          ; AL = a = 10
        mov AH, [d]          ; AH = d = 8
        mul AH               ; AL:AH <- AX = a * d = 80
        
        mov BX, AX           ; BX = AX = a * d = 80
        
        mov AL, [b]          ; AL = b = 15
        mov AH, [c]          ; AH = c = 5
        mul AH               ; AL:AH <- AX = b * c = 75
        
        add BX, AX           ; BX = AX - BX = a * d + b * c = 155

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
