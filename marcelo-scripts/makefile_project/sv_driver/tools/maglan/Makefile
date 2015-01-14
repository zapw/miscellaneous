###############################################################
#											                                                                   #
#  Makefile for Maglan (Graphical version of sv driver tool)								   #
#                                                           												  #
###############################################################

ifeq "$(wildcard  /bin/qmake)" ""
	QMAKE_EXIST=0
else 
	#QMAKE_EXIST=1
	QMAKE_EXIST=0
endif

all: 
	$(MAKE) -C src
ifeq ($(QMAKE_EXIST), 1)
	$(MAKE) -C Maglan-Qt
endif

install:
	$(MAKE) -C src $@
ifeq ($(QMAKE_EXIST), 1)
	$(MAKE) -C Maglan-Qt $@
endif

clean:
	$(MAKE) -C src $@
ifeq ($(QMAKE_EXIST), 1)
	$(MAKE) -C Maglan-Qt $@
endif

test-qmake: 
	@echo "qmake exist? -  $(QMAKE_EXIST)"

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
