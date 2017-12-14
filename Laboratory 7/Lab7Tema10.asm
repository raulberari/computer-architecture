bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 01011100b, 10001001b, 11100101b
    len equ $-s
    d times len db 0
    
; our code starts here
segment code use32 class=code
    start:
        mov ESI, s ;
        cld ; we iterate from left to right (DF = 0)
        mov ECX, len ; mainLoop iterator
        mov EDX, len - 1 ; we place the mirrored numbers from right to left
        
        mainLoop:
            mov AH, 8 ; mirror loop iterator
            mov BL, 0 ; we reset BL to 0
            
            lodsb ; we store the current byte from s in AL
            
            mirrorLoop:
                rcr AL, 1
                rcl BL, 1 ; we build the mirrored byte in BL
                
                dec AH ; we decrease the iterator
                cmp AH, 0 ; and then compare it to 0
                 
                jne mirrorLoop ; if it is 0, we exit the mirror loop
            
            mov [d + EDX], BL ; move the mirrored byte in d from right to left
            dec EDX ; decrease the main loop iterator
            
        loop mainLoop
            
            
        
        done:
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
