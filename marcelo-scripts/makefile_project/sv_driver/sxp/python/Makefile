###############################################################
#                                                             #
#  Makefile for sxpWrapper
#                                                             #
###############################################################

USE_NEVADA = 0



INCLUDES = \
	-I../api/inc\
	-I../../api/inc

LIBDIRS = \
	-L../api/src\
	-I../../api/lib

LIBS = -lSxpApi 

CPPFLAGS =$(INCLUDES) $(DEFINES) $(GENERAL_DEFINES) -Wall -fpic
SWIGFLAGS=$(INCLUDES) $(DEFINES) -Wall
CC = g++


ifeq ($(shell cat /etc/redhat-release), Laughlin)
@echo UUUUU
endif



LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS)

PYTHON_TARGET_SO = _sxp.so
PYTHON_LIB = python2.6


ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
CPPFLAGS += -DX86_64
DEFINES += -DX86_64
else
LIBS_DIR = /usr/lib
endif


ifeq "$(strip $(shell cat /etc/redhat-release))" "Fedora release 14 (Laughlin)"
	PYTHON_LIB = python2.7
else
	PYTHON_LIB = python2.6
endif

PYTHON_INC = \
	-I/usr/include/python2.6/\
	-I/usr/include/python2.7/


all: python

install: install_python


	
python: python_swig python_compile 
	@echo hhh $KKK
	$(CC) -shared -o $(PYTHON_TARGET_SO) sxpWrapper.o sxpWrapper_python.o $(CPPFLAGS) $(LDFLAGS)


install_python:
	@echo $(LIBS_DIR)
	sudo cp *.py $(LIBS_DIR)/$(PYTHON_LIB)
	sudo cp $(PYTHON_TARGET_SO) $(LIBS_DIR)/$(PYTHON_LIB)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(PYTHON_LIB)/$(PYTHON_TARGET_SO)



python_compile: python_swig
	rm -f sxpWrapper_wrap.o
	$(CC) -fpic -c sxpWrapper.cxx sxpWrapper_wrap.cxx $(PYTHON_INC) -I$(LIBS_DIR)/$(PYTHON_LIB)/config/ $(CPPFLAGS)
	cp sxpWrapper_wrap.o sxpWrapper_python.o


python_swig:
	swig -python -c++ $(SWIGFLAGS) -DPYTHON sxpWrapper.i
	

	
clean:
	rm -f $(OBJECTS) *.o *.so sxpWrapper_python.cxx sxp.py *.pyc

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
