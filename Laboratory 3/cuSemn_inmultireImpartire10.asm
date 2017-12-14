; signed
; a, c - byte; b - word; d - doubleword; x - qword
; d - ((7 - a * b + c) / a) - 6 + (x / 2)
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
    a db 2
    b dw 10
    c db 100
    d dd 1000
    x dq 100
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov BX, [b] ; AX = b 
        mov DX, 0

        imul byte[a] ; DX:AX = a * b 
        
        
        push DX
        push AX
        pop EAX ; EAX = a * b
        
        mov EBX, 7
        sub EBX, EAX ; EBX = 7 - a * b
        
        ; trebuie sa convertim c la dword
        mov AL, byte[c]
        cbw ; conversie cu semn AL la AX, AX = c 
        cwd ; conversie cu semn de la AX la DX:AX, DX:AX = c
        
        push DX
        push AX
        pop EAX ; EAX = DX:AX = c
        
        add EBX, EAX ; EBX = 7 - a * b + c
        
        ; a trebuie convertit la word
        mov AL, [a]
        cbw ; conversie cu semn din AL la AX, AX = a
        
        mov CX, AX ; CX = a
        mov EAX, EBX ; EAX = 7 - a * b + c
        
        push EAX
        pop AX
        pop DX
        
        idiv CX ; impartim fara semn DX:AX la CX, AX = (7 - a * b + c) / a
        mov DX, 0
        
        push DX
        push AX
        pop EAX ; EAX = (7 - a * b + c) / a
        
        mov BX, word[d]
        mov CX, word[d + 2] ; CX:BX = d 
        
        push CX
        push BX
        pop EBX ; EBX = d 
        
        sub EBX, EAX ; EBX = d - (7 - a * b + c) / a = 957
        
        mov EAX, 6
        
        sub EBX, EAX ; EBX = d - (7 - a * b + c) / a - 6 = 951
        
        
        mov EAX, dword[x]
        mov EDX, dword[x + 4] ; EDX:EAX = x
        
        mov ECX, 2
        
        idiv ECX ; EAX = x / 2
        
        add EAX, EBX ; EAX = d - (7 - a * b + c) / a - 6 + (x / 2) = 1001
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
