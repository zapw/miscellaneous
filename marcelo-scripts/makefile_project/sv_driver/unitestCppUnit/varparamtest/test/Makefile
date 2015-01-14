CPPFLAG = -std=c++0x -g3 -ggdb
LIB = -L../lib -lvarparamtest -lcppunit 
INC = -I../inc -I/usr/include/cppunit -I../param/inc
OBJ = GlobalParamTest.o main.o UniTest_1.o
PROG = utest

.PHONY: all

vpath %.a ../lib
all: $(PROG)

$(PROG): $(OBJ) libvarparamtest.a
	g++ $(INC) $(CPPFLAG) $(OBJ) $(LIB) -o $(PROG)

libvarparamtest.a:
	$(MAKE) -C ..

GlobalParamTest.o: GlobalParamTest.cpp GlobalParamTest.h
	g++ -c $< $(INC) $(CPPFLAG) -o $@ 

UniTest_1.o: UniTest_1.cpp UniTest_1.h
	g++ -c $< $(INC) $(CPPFLAG) -o $@ 

main.o: main.cpp
	g++ -c $< $(INC) $(CPPFLAG) -o $@ 

clean:
	rm -f *.o $(PROG)

clean-all:
	rm -f *.o $(PROG)
	$(MAKE) clean -C ..

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
