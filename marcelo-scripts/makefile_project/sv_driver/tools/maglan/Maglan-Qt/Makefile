###############################################################
#											                                                                   #
#  Makefile for Maglan Qt version
#                                                           							
###############################################################

ifeq "$(wildcard  Maglan/Makefile)" ""
	MAKE_EXIST=0
else 
	MAKE_EXIST=1
endif


.PHONY: cleanfiles all install clean
cleanfiles: all
	#only deletes intermidiate files and not the executable
	$(MAKE) -C Maglan clean

all: 
	/bin/qmake -o Maglan/Makefile Maglan/Maglan.pro
	$(MAKE) -C Maglan

install:
	sudo cp Maglan/Maglan /usr/bin/maglan

clean:
ifeq ($(MAKE_EXIST), 1)
	$(MAKE) -C Maglan clean
endif
	rm -f Maglan/Maglan

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
