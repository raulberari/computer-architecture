; the program computes the equation (a + d + d) - c +(b + b)
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 10
    b db 7
    c db 5
    d db 8

; our code starts here
segment code use32 class=code
    start:

        mov AL, [a]          ; AL = a = 10
        mov AH, [d]          ; AH = d = 8
        add AL, AH           ; AL = a + d = 18
        add AL, AH           ; AL = a + d + d = 26

        mov AH, [b]          ; AH = b = 7
        add AH, AH           ; AH = b + b = 14

        mov BL, [c]          ; BL = c = 5

        sub AL, BL           ; AL = (a + d + d) - c = 21

        add AL, AH           ; AL = (a + d + d) - c + (b + b) = 35
        
        mov [c], AL 
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
