bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
; 

import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db 1, 4, 2, 4, 8, 2, 1, 1, 3, 5, 3, 7, 7, 3, 5, 7 ; initial list declaration
    len equ $-s ; getting the length of the list
    d times len db 0 ; reserving space for another list of dimension len named d
    
    ; format db "%d", 0

; our code starts here
segment code use32 class=code
    start:
        mov ECX, 0 ; we set the outer loop iterator ECX to 0
        mov ESI, 0 ; we set the iterator for adding to d to 0
        
        outerLoop: ; we iterate trough the numbers of s and compare each of them to the numbers in d
            cmp ECX, len ; we compare the iterator ECX to the length of the list
            je done ; if we went through all the steps we're done
            
            mov EBX, 0 ; we set the iterator EBX for the inner loop
            mov AL, [s + ECX] ; we move the current number from s in AL
            
        innerLoop: ; we iterate through the numbers from d
            mov DL, [d + EBX] ; we move the current number from d in DL
            cmp AL, DL ; we compare them
            je innerLoopDone ; if the number from s is already in d we won't add it so we'll skip iterating d
           
            cmp EBX, len ; we compare the inner loop iterator EBX with the length of d
            je addNumber ; if we've iterated through all the d list without finding the number from s, then we'll
                         ; add it to d
            inc EBX ; we increment the inner loop iterator
            jmp innerLoop ; we repeat the inner loop
            
        addNumber: ; we will add the number only when we've iterated through all the elements of d
            mov [d + ESI], AL ; move the number from s into the position in d
            inc ESI ; increment the position on which we add it
        
        innerLoopDone: ; after the inner loop is done
            inc ECX ; we increment the outer loop iterator
            jmp outerLoop ; and then jump back to it 
            
        done:
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
