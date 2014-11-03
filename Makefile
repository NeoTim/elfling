all: bin/prt bin/prt2

bin:
	mkdir bin

bin/bin2h: bin bin2h.c
	gcc -std=c99 bin2h.c -o bin/bin2h 
	
header.h: header.asm bin/bin2h
	nasm header.asm -f bin -o bin/header.bin
	bin/bin2h bin/header.bin header.h header
	ls -al bin/header.bin

bin/elfling: elfling.cpp header.h pack.c
	gcc -std=c99 -O3 -g pack.c -c -o bin/pack.o
	g++ -std=c++11 -g elfling.cpp bin/pack.o -o bin/elfling

bin/crunkler_2: crunkler_2.cpp
	g++ -std=c++11 -g crunkler_2.cpp  -o bin/crunkler_2
	
bin/prt.o: prt.c bin
	gcc -c prt.c -fomit-frame-pointer -fno-exceptions -o bin/prt.o -m32
	
bin/prt: bin/prt.o
	gcc bin/prt.o -s  -nostartfiles -o bin/prt -m32
	
bin/prt2: bin/prt.o bin/elfling
	bin/elfling bin/prt.o -obin/prt2  -llibc.so.6 #-fnosh
	chmod 755 bin/prt2

bin/flow2: flow2.c bin/elfling
	gcc -c flow2.c -fomit-frame-pointer -fno-exceptions -ffast-math -fsingle-precision-constant -o bin/flow2.o -m32
	bin/elfling bin/flow2.o -obin/flow2  -llibSDL-1.2.so.0 -llibGL.so.1 #-fnosh
	chmod 755 bin/flow2

