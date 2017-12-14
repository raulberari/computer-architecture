; signed
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
    c dd 300
    d dq 80
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; pentru a calcula a + d + d trebuie sa convertim a la qword
        mov AL, [a]
        cbw ; conversie cu semn de la AL la AX
        cwd ; conversie cu semn de la AX la DX:AX 
        ; DX:AX = a
        
        push DX
        push AX
        pop EAX ; EAX = a
        
        cdq ; conversie cu semn de la EAX la EDX:EAX = a
        add EAX, dword[d] 
        adc EDX, dword[d + 4] ; EDX:EAX = a + d
        
        add EAX, dword[d] 
        adc EDX, dword[d + 4] ; EDX:EAX = a + d + d
        
        sub EAX, dword[c]
        sbb EDX, 0 ; EDX:EAX = (a + d + d) - c
        
        ; sbb EDX, word[c + 2] 
        
        mov EBX, EAX
        mov ECX, EDX ; mutam EDX:EAX in ECX:EBX = (a + d + d) - c
        
        mov AX, [b] ; AX = b
        add AX, word[b] ; AX = b + b
        
        cwd ; convertim cu semn AX la DX:AX
        
        push DX
        push AX
        pop EAX ; EAX = b + b 
        
        cdq ; EDX:EAX = b + b conversie cu semn de la EAX la EDX:EAX
        
        add EAX, EBX
        adc EDX, ECX ; EDX:EAX = (a + d + d) - c + (b + b)
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
