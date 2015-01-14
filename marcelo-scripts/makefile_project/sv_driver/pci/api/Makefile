all:
	$(MAKE) -C src/
clean:
	$(MAKE) -C src/ clean
install:
	$(MAKE) -C src/ install

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
