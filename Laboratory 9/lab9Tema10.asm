; Read a file name (30 chars) and a message (120 chars) from console and save the message to the file.
bits 32

global start        

; declararea functiilor externe folosite de program
extern exit, printf, fprintf, gets, fopen, fclose            
import exit msvcrt.dll    
import printf msvcrt.dll    ; indicam asamblorului ca functia printf se gaseste in libraria msvcrt.dll
import gets msvcrt.dll
import fopen msvcrt.dll  
import fclose msvcrt.dll
import fprintf msvcrt.dll
                          
segment data use32 class=data
	fileName times 30 db 0 ; reserving 30 bytes for the name
	message times 120 db 0 ; reserving 120 bytes for the message
    
    fileNameMessage db "Filename=", 0
    messageMessage db "Message=", 0
    
    accessMode db "w", 0 ; to be used in the call fopen(fileName, accessMode) 
    fileDescriptor dd -1
    
segment code use32 class=code
    start:
        read:
        push dword fileNameMessage
        call [printf] ; prints the file name input message
        add esp, 4 * 1
        
        push dword fileName
        call [gets] ; reading the file name with gets()
        add esp, 4 * 1 ; clearing the stack

        push dword messageMessage
        call [printf] ; prints the message input message
        add esp, 4 * 1
        
        push dword message
        call [gets] ; reading the message with gets()
        add esp, 4 * 1 ; clearing the stack
        
        createTheFile:
        ; eax = fopen(fileName, accessMode)
        push dword accessMode    
        push dword fileName
        call [fopen] ; creating the file 
        add esp, 4 * 2               

        mov [fileDescriptor], eax ; moving the returned value from fopen into eax
        
        ; if eax != 0, then the file was successfully created
        cmp eax, 0
        je final ; in the other case, we skip to the end
            
        writeToFile:
        ; fprintf(fileDescriptor, message)
        push dword message
        push dword [fileDescriptor]
        call [fprintf]
        add esp, 4 * 2        
            
        closeTheFile:
        ; fclose(fileDescriptor)
        push dword [fileDescriptor]
        call [fclose]
        add esp, 4 * 1
        
        final:
        
        ; exit(0)
        push dword 0      ; punem pe stiva parametrul pentru exit
        call [exit]       ; apelam exit pentru a incheia programul