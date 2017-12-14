bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 12h, 3h
    b dw -2, 3, -4, 8, -8
    c dd 78F8BCDh
    d dw 88h, 0Ah, 0FFh
    
    
    len equ $-a
    e times len db 0 ; new list of negative numbers
    
    n db 0
    m db 0
    
    
    
    isMultipleMessage db "n e multiplu de 3", 0
    isNotMultipleMessage db "n nu este multiplu 3, ", 0
    positionMessage db "octetul in memorie de pe pozitia data este %x, ", 0
    numberMessage db "%x, ", 0
    
    
; our code starts here
segment code use32 class=code
    start:
    
        mov DL, len 
        mov EAX, dword[c]
        
        and EAX, 00000000000000000000000011110000b ; vom avea in AL bitii 4-7 ai lui c si bitii 0-3 vor fi 0
        shr EAX, 4 ; EAX = 0000 0000 0000 0000 0000 0000 0000 1100
        mov [n], AL ; n = 0000 1100b
        
        mov EAX, dword[c]
        shr EAX, 12 ; shiftam cu 12 bitii din EAX
        and EAX, 00000000000000000000000011110000b ; izolam bitii 4-7 adica bitii 16-19 ai lui c
                                                   ; vom avea in AL 1111 0000b
        
        or [n], AL ; n devine 1111 1100b = FCh = -4 cu semn
        
        mov AL, [n]
        cbw
        
        mov CL, 3
        idiv CL ; impartim pe n la 3, AL = AX/3, AH = AX%3
        
        cmp AH, 0
        je isMultiple
        
        isNotMultiple:
            ; jmp done ;TEMPORAR 
            push dword isNotMultipleMessage
            call [printf]
            add ESP, 4 * 1
            
            jmp done
            
        isMultiple:    
            push dword isMultipleMessage
            call [printf]
            add ESP, 4 * 1
            
        done:
        
        mov AL, [n]
        add AL, 10h ; AL devine -4 + 16 = 12, m = 12
        cbw
        cwd
        
        mov ESI, EAX ; ESI = m = 12
        mov BL, [a + ESI] ; byte-ul cu indexul m se calculeaza in BL
        mov AL, BL ; AL = byte-ul cu index m
        mov AH, 0
        cwd
        
        ; jmp skipPrint ; temporar
        push EAX 
        push dword positionMessage
        call [printf]
        
        add ESP, 4 * 2
        
        skipPrint:
        mov ECX, 0
        mov EDX, 0
        negativeLoop:
            cmp ECX, ESI
            je loopDone
            
            mov AL, [a + ECX]
            
            cmp AL, 0
            jge isPositive 
            
            mov [e + EDX], AL
            inc EDX
            
            
            isPositive:
            inc ECX
            jmp negativeLoop
        loopDone:
        
        ; EDX - iterator al sirului de numere negative
        mov ECX, 0
        printLoop:
            cmp ECX, EDX
            je printLoopDone
            
            mov AL, [e + ECX]
            mov AH, 0
            cwd
            
            push EAX
            push numberMessage
            call [printf]
            
            add ESP, 4 * 2
            
            inc ECX
            jmp printLoop
            
            
        printLoopDone:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
