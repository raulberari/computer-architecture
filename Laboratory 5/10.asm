bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
; Sa se inlocuiasca bitii 0-3 ai octetului B cu bitii 8-11 ai cuvantului A
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 1111010010100100b 
    b db 01001011b
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov AX, [a] ; AX = 11110100 10100100b 
        mov BL, AH ; BL = AH = 11110100b
        and BL, 00000111b ; BL = 00000100b
        
        mov AL, [b] ; AL = b = 01001011b
        and AL, 11111000b ; AL = 01001000b
        
        or AL, BL ; AL = 01001100b = 4Ch
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
