section .text
	global _start

_start:
	nop
	mov eax,5 		; get ready for open call
	mov ebx,myFile  ; open the test file. It contains
					; one line 'this is a test'
	mov ecx,0 		; open test file in read only mode
	int 0x80 		; trap to kernel for open()
	
readOne:
	push eax 		; keep the file descriptor by pushing
					; eax on the stack
	mov ebx,eax 	; get ready to call read
					; the file descriptor is passed to read
					; via ebx
	mov eax,3 		; eax now points to read()
	mov ecx,oneByte ; read byte will be stored in oneByte
	mov edx,1 		; read only 1 byte
	int 0x80 		; trap to kernel for read()
	pop eax 		; restore file descriptor to eax
					; by popping 4 bytes of the stack
	
writeOne:
					; get ready to call write
	mov ebx,eax		; pass fd via ebx
	mov eax,4		; eax now points to write()
	mov ebx,1		; write to stdout
	mov ecx,oneByte ; write from oneByte location
	mov edx,1		; only the single byte stored there
	int 0x80		; trap to kernel

exit:
	mov eax,1
	mov ebx,0
	int 0x80 ; exit gracefully

section .data

myFile db '/home/jon/Assembly/PopAndPush/test'

section .bss
oneByte: resb 1
