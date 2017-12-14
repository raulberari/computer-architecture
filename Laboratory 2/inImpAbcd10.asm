; the program computes the equation 3 * (20 * (b - a + 2) - 10 * c) / 5
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
    d dw 8

; our code starts here
segment code use32 class=code
    start:
        mov AL, [b]          ; AL = b = 15
        mov AH, [a]          ; AH = a = 10
        sub AL, AH           ; AL = b - a = 5
        add AL, 2            ; AL = b - a + 2 = 7
        
        mov BL, 20           ; BL = 20
        mul BL               ; AL * BL <- AX = 20 * (b - a + 2) = 140
        
        mov BX, AX           ; BX = AX = 140
        mov AL, 10           ; AL = 10
        mov AH, [c]          ; AH = c = 5
        mul AH               ; AL * AH <- AX = 10 * c = 50
        
        sub BX, AX           ; BX = BX - AX = 20 * (b - a + 2) - 10 * c = 90
        
        mov AX, BX           ; AX = BX = 20 * (b - a + 2) - 10 * c = 90
        
        mov BX, 3            ; BX = 3
        mul BX               ; AX * BX = AX:DX = 3 * (20 * (b - a + 2) - 10 * c) = 270
        
        push DX              
        push AX
        pop EAX              ; EAX = 3 * (20 * (b - a + 2) - 10 * c) = 270
        
        mov BX, 5            ; BX = 5
        div BX               ; EAX / BX -> AX = EAX / BX = 3 * (20 * (b - a + 2) - 10 * c) / 5 = 54 
        

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
