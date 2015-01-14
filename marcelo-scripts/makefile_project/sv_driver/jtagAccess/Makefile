.PHONY: src ftcjtag clean default all install

default: all

all:
	$(MAKE) -C src
	
install:
	$(MAKE) -C src install
	
clean: ftcjtag src

ftcjtag src:
	$(MAKE) -C $@ clean

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
