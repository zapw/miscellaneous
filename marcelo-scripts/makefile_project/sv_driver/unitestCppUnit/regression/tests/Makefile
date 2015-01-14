all: default

default:
	$(MAKE) -C src/

clean:
	$(MAKE) -C src/ clean


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
