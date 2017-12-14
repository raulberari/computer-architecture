; Se dau octetii A si B. Sa se obtina dublucuvantul C:
; bitii 16-31 ai lui C sunt 1
; bitii 0-3 ai lui C coincid cu bitii 3-6 ai lui B
; bitii 4-7 ai lui C au valoarea 0
; bitii 8-10 ai lui C au valoarea 110
; bitii 11-15 ai lui C coincid cu bitii 0-4 ai lui A
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 10100111b
    b db 10101110b
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov EAX, 0;
        or EAX, 11111111111111110000011000000000b; EAX = 11111111 11111111 00000110 00000000b
        mov BL, [b] ; BL = b = 10101110b
        mov BH, 0 
        mov CX, 0 ; CX:BX = b = 00000000 10101110b
        
        push CX
        push BX
        pop EBX ; EBX = b = 00000000 00000000 00000000 10101110b
        
        shr EBX, 3 ; EBX = 00000000 00000000 00000000 00010101b
        and EBX, 00000000000000000000000000000111b ; EBX = 00000000 00000000 00000000 00000101b
        
        or EAX, EBX ; EAX = 11111111 11111111 00000110 00000101b
        
        mov BL, [a] ; BL = a = 10100111b
        mov BH, 0
        mov CX, 0 ; CX:BX = a = 00000000 10100111b
        
        push CX
        push BX
        pop EBX ; EBX = a = 00000000 00000000 00000000 10100111b
        
        and EBX, 00000000000000000000000000011111 ; EBX = a = 00000000 00000000 00000000 00000111b
        shl EBX, 11 ; EBX = a = 00000000 00000000 00111000 00000000b
        
        or EAX, EBX ; EAX = 11111111 11111111 00111110 00000101b = FFFF3E05h
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
