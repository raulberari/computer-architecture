bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf            ; tell nasm that exit exists even if we won't be defining it
import scanf msvcrt.dll
import printf msvcrt.dll
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                        ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a dd 0
    
    result_message db "%d (10) = %x (16)", 0 ; se declara mesajul de sfarsit
    int32_format db "%d", 0 ; se declara formatul pentru citirea unui numar in baza 10
    

segment code use32 class=code
    start:
        push dword a ; se pun pe stiva numarul in baza 10 si formatul pentru citire
        push dword int32_format
        call [scanf] ; se apeleaza functia de citire 
        
        add ESP, 4 * 2 ; se elibereaza stiva
        
        push dword [a] ; se pun pe stiva numarul in baza 10, nr in baza 16 si mesajul de afisare
        push dword [a]
        push dword result_message
        call [printf] ; se apeleaza functia de afisare
        
        add ESP, 4 * 3 ; se elibereaza stiva
        
        ; exit
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
