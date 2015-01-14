
.PHONY: all libso stat clean install
all:	
	$(MAKE) -C src all

libso:
	$(MAKE) -C src lib

stat:
	$(MAKE) -C src stat
			
clean:
	$(MAKE) -C src clean

install:
	$(MAKE) -C src install

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
