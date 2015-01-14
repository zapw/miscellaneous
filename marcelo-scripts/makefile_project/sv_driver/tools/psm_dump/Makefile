###############################################################
#											                                                                   #
#  Makefile for GSVDT (Graphical version of sv driver tool)								   #
#                                                           												  #
###############################################################
.DELETE_ON_ERROR:

PROGRAM = psm-dump
EXE = $(PROGRAM)
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
	-I../../jtagAccess/inc\
	-I/usr/include/sv_driver/api\
	-I/usr/include/services/Utilities\
	-I/usr/include/services/RegisterFields

LIBDIRS = \
	-L../../api/lib\

LIBS = -lDriverApi  -ldl -lpci -lboost_system-mt -lDriverIwarpApi -lboost_regex -lUtilities -lgUtilities -lRegisterFields

SOURCES = psmDump.cpp psmTable.cpp GTree.cpp


OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files
CPPFLAGS = $(WXCXXFLAGS) $(INCLUDES) $(DEFINES) -Wall -g
CC = g++

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

all: $(PROGRAM)

vpath %.so ../../api/lib
$(PROGRAM): $(HFILES) $(OBJECTS) libDriverIwarpApi.so libDriverApi.so
	$(CC) $(WXCXXFLAGS) -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS)

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib


install:
	$(SUDO) install -d $(DESTDIR)/usr/bin
	$(SUDO) install -m 0755 $(EXE) $(DESTDIR)/usr/bin

clean:
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
%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(WXCXXFLAGS) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
