; unsigned
; a - byte, b - word, c - double word, d - qword
; (a + d + d) - c + (b + b)
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
    a db 100
    b dw 50
    c dd 25
    d dq 80
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; pentru a calcula a + d + d trebuie sa convertim a la qword
        mov AL, [a]
        mov AH, 0 ; conversie fara semn de la AL la AX
        mov DX, 0 ; conversie fara semn de la AX la DX:AX 
        ; DX:AX = a
        
        push DX
        push AX
        pop EAX ; EAX = a
        
        mov EDX, 0 ; EDX:EAX = a
        add EAX, dword[d] 
        adc EDX, dword[d + 4] ; EDX:EAX = a + d
        
        add EAX, dword[d] 
        adc EDX, dword[d + 4] ; EDX:EAX = a + d + d
        
        ;pentru a scadea c trebuie sa il convertim la qword
        mov EBX, dword[c] ; EBX = c
        mov ECX, 0 ; ECX:EBX = c
        
        sub EAX, EBX 
        sbb EDX, ECX ; EDX:EAX = (a + d + d) - c
        
        mov BX, [b] ; BX = b
        add BX, word[b] ; BX = b + b
        
        mov CX, 0 ; CX:BX = b + b
        
        push CX
        push BX
        pop EBX ; EBX = b + b 
        
        mov ECX, 0 ; conversie fara semn de la EBX la ECX:EBX ECX:EBX = b + b
        
        add EAX, EBX
        adc EDX, ECX ; EDX:EAX = (a + d + d) - c + (b + b)
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
