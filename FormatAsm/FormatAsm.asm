
section .data
tabsize db 4
asmfile db '/home/jon/Assembly/FormatAsm/test.asm'
READWRITE dw 2

section .bss
ccount resb 1
ocount resb 1
lastchar resb 1
asm_fd resw 1
currentchar resb 1

section .text
global _start

_start:
    mov [ccount], byte 0
    mov [ocount], byte 0


loadAsmFile:							; open the asm file for formatting                                      
	mov eax, 5							; open file test.asm
	mov ebx, [asmfile]					; pass full file name to open()
	mov ecx, [READWRITE]				; open the file for read and write
	int 0x80							; trap to kernel for sys_open()
	
	mov [asm_fd], eax					; save the file descriptor into asm_fd variable

readchar:
	
	mov eax, 3							; read() character from asm file that's being formatted
	mov ebx, [asm_fd]					; pass the file descriptor for the asm file to read()
	mov ecx, currentchar				; store the read character at currentchar
	mov edx, 1							; read only a single byte from the file
	int 0x80							; trap to kernel for sys_read()
	
    cmp [currentchar], 0                ; check to see if the newly read character was a newline
    je return							; and if it was you should? return
    
    cmp eax, 0x9			            ; encountered tab
    je whitespace
    cmp eax, 0x20		                ; encountered space
    je whitespace
    cmp eax, 0x80000000                 ; sys_read returned an error
    jge error_return                
    cmp eax, 0xA		                ; encountered newline character
    je newline
    
    jmp character                       ; if it gets here a normal character was read

newline:
    jmp return                          ; read a newline character
    
character:
                                        ; read a character that wasn't whitespace, EOF, \n, or semi colon
    inc byte [ccount]                   ; increment line length by 1
    mov byte [ocount], byte [ccount]
    mov [lastchar], al                  ; put the last character read into lastchar
    jmp readchar                        ; read the next character
    
whitespace:
    cmp lastchar, 0x20000000            ; last character was a space
                                        ; so don't update ocount
    je whitespace_space
    cmp lastchar, 0x00000009            ; last character was a tab
    je whitespace_tab                   ; so don't update ocount
    
whitespace_space:
    inc byte [ccount]
    jmp readchar
whitespace_tab:
    add byte [ccount], byte [tabsize]
    jmp readchar
    
error_return: 
                                        ; clean stack and return to caller
return:
                                        ; clean stack and return to caller
                                        ; for now just print ccount for testing
    

