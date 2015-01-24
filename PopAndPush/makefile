pop_push: pop_push.o
	ld -melf_i386 pop_push.o -o pop_push 

pop_push.o: pop_push.asm
	nasm -f elf32 pop_push.asm
