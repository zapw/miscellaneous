###############################################################
#                                                             #
#      Makefile for SVDT (Sv driver tool)  application        #
#                                                             #
###############################################################
.DELETE_ON_ERROR:
PROGRAM = svdt
EXE = svdt
DESTDIR?=/# SVOS

# Determine which OS and version is running
OS_NAME := $(shell cat /etc/os-release | grep -w NAME | cut -d '=' -f2)
OS_VERSION := $(shell cat /etc/os-release | grep -w VERSION_ID | cut -d '=' -f2)
OS_PLATFORM := $(shell uname -m)

ifneq ($(OS_NAME), "Intel SVOS")
ifneq ($(OS_NAME), "Debian GNU/Linux")
SUDO := sudo
endif
endif

INCLUDES = \
	-I./inc\
	-I../../api/inc\
	-I../common\
	-I/usr/include/sv_driver/api\
	-I./libtecla\
	-I../../i200e/shared\
	-I../../i40e/shared

LIBDIRS = -L./libtecla\
	-L../../api/lib\
	-L../../api/iwarp/lib


LIBS = -ltecla -lDriverApi -lDriverIwarpApi -ldl -lpci -lboost_system

SOURCES = 	Svdt.cpp\
		CmdParser.cpp\
		CommandExec.cpp\
		IxgbeCommandExec.cpp\
		DriverLog.cpp

extras = ../common/DriverEvents.cpp\
        ../common/PacketCollector.cpp

extra_objects_nodir = $(patsubst %.cpp,%.o,$(notdir $(extras)))
extra_objects = $(patsubst %.cpp,%.o,$(extras))


OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files
CPPFLAGS = $(INCLUDES) -Wall -g
CC = g++
DBG = -g
LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS)


.PHONY: all libclean
all: $(PROGRAM) 

vpath %.so ../../api/lib ../../api/iwarp/lib
vpath %.a  ./libtecla
vpath %.o ../common

$(PROGRAM): $(HFILES) $(OBJECTS) libtecla.a libDriverIwarpApi.so libDriverApi.so $(extra_objects)
	$(CC) -o $@ $(OBJECTS) $(extra_objects) $(DBG) $(INCLUDES) $(LDFLAGS)

DriverEvents.o PacketCollector.o:
	$(MAKE) -C ../common $@

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp/src lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

libtecla.a:
	$(MAKE) -C libtecla

libclean:
	$(MAKE) -C ./libtecla clean

../../remoting/Rcf:
	$(MAKE) -C ../../remoting Rcf

install:
	$(SUDO) install -d $(DESTDIR)/usr/bin
	$(SUDO) install -m 0755 svdt $(DESTDIR)/usr/bin

clean: libclean
	$(RM) -f $(OBJECTS) $(EXE) $(includes)

run:
	./$(PROGRAM)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(SOURCES),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F)) | ../../remoting/Rcf
	$(CC) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
