.PHONY: all clean install 

all clean install:
	$(MAKE) -C src/ $(filter-out all,$@)



#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
