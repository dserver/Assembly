hello: hello.o
	ld -melf_i386 hello.o -o hello

hello.o: hello.asm
	nasm -f elf32 hello.asm
