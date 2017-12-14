; se citeste de la tastatura numele unui fisier
; sa se citeasca continutul acelui fisier si sa se extraga in alte doua fisiere
; toate cifrele pare, respectiv toate cifrele impare
bits 32

global start        

; declararea functiilor externe folosite de program
extern exit, printf, fprintf, fread, gets, fopen, fclose            
import exit msvcrt.dll    
import printf msvcrt.dll    
import gets msvcrt.dll
import fopen msvcrt.dll  
import fclose msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll
                          
segment data use32 class=data
	readFileName times 255 db 0 ; reserving 255 bytes for the file name
	buffer times 100 db 0 ; reserving 100 bytes for the buffer
    numberOfReadCharacters dd 0
    
    letter_0 db "0"
    letter_9 db "9"
    
    fileNameMessage db "Filename=", 0
    
    evenFileName db "even.txt", 0
    oddFileName db "odd.txt", 0
    
    readAccessMode db "r", 0 ; to be used in the call fopen(fileName, accessMode) 
    writeAccessMode db "w", 0
    readFileDescriptor dd -1
    evenFileDescriptor dd -1
    oddFileDescriptor dd -1
    
    formatDecimal db "%c",0
    
segment code use32 class=code
    start:
        openFiles:
        push dword fileNameMessage
        call [printf] ; prints the file name input message
        add esp, 4 * 1
        
        push dword readFileName 
        call [gets] ; reading the file name with gets()
        add esp, 4 * 1 ; clearing the stack
        
        ; opening the file from which we read
        push dword readAccessMode    
        push dword readFileName
        call [fopen] ; opening the file 
        add esp, 4 * 2          
        mov [readFileDescriptor], eax ; moving the returned value from fopen into eax

        ; opening the file for the even numbers
        push dword writeAccessMode    
        push dword evenFileName
        call [fopen] ; opening the file 
        add esp, 4 * 2   
        mov [evenFileDescriptor], eax ; moving the returned value from fopen into eax
        
        ; opening the file for the odd numbers
        push dword writeAccessMode    
        push dword oddFileName
        call [fopen] ; opening the file 
        add esp, 4 * 2  
        mov [oddFileDescriptor], eax ; moving the returned value from fopen into eax

        readFromFile:
            ; we read a part (100 chars) from readFileName
            ; eax = fread(buffer, 1, 100, readFileDescriptor)
            push dword [readFileDescriptor]
            push dword 100
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4 * 4
            
            ; eax holds the number of read chars
            cmp eax, 0
            je closeTheFiles
            
            mov ecx, eax
            mov esi, buffer
            
            
            ; copy characters into their respective files
            writeCharToFile:
                ; fprintf(fileDescriptor, message)
                push ecx
                lodsb 
                
                cmp al, [letter_0]
                jl doneWriting
                
                cmp al, [letter_9]
                jg doneWriting
                
                test al, 0x01
                jz par
                
                impar:
                cbw
                cwd
                push eax
                push dword formatDecimal
                push dword [oddFileDescriptor]
                call [fprintf]
                add esp, 4 * 3
                jmp doneWriting
                
                par:
                cbw
                cwd
                push eax
                push dword formatDecimal
                push dword [evenFileDescriptor]
                call [fprintf]
                add esp, 4 * 3
                
                doneWriting:
                pop ecx
                dec ecx
                cmp ecx, 0
                jnz writeCharToFile
                
            
            jmp readFromFile
        
        closeTheFiles:
        ; fclose(fileDescriptor)
        push dword [readFileDescriptor] ; read file is closed
        call [fclose]
        add esp, 4 * 1
        
        push dword [evenFileDescriptor] ; even file is closed
        call [fclose]
        add esp, 4 * 1
        
        push dword [oddFileDescriptor] ; odd file is closed
        call [fclose]
        add esp, 4 * 1
        
        ; exit(0)
        push dword 0      ; punem pe stiva parametrul pentru exit
        call [exit]       ; apelam exit pentru a incheia programul