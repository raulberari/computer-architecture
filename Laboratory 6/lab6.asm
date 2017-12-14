bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 'a', 'b', 'c', 'm', 'n'
    l equ $-s
    d times l db 0

; our code starts here
segment code use32 class=code
    start:
        mov ECX, l
        mov ESI, 0
        jECXz = Sf
        
        Repeta:
            mov AL, [s + ESI]
            mov BL, 'a' - 'A'
            
            sub AL, BL
            mov [d + ESI], AL
            inc ESI
        loop Repeta
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
