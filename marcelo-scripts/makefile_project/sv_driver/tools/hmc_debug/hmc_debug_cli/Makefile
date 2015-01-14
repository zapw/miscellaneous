###############################################################
#											                                                                   #
#  Makefile for HMC debug tool Cli							   #
#                                                           												  #
###############################################################
.DELETE_ON_ERROR:

PROGRAM = hmcDebugCli
EXE = $(PROGRAM)

INCLUDES = \
	-I/usr/include/sv_driver/api/ \
	-I/usr/include/sv_driver/api/iwarp \
	-I/usr/include/sv_driver/api \
	-I../../../tools/HmcDebug\
	-I../../../tools/hmc_debug/hmc_debug_lib/inc\
	-I../../../api/inc\
	-I../../../api/iwarp/inc\
	-I../../../nes/shared\
	-I../../../i40e/shared\
	-I../../../i200e/shared

LIBDIRS = -L../hmc_debug_lib/lib\
	-L../../../api/lib\
	-L../../../api/iwarp/lib\
	-L../../../pci/api/src\
	-L../../../jtagAccess/src\

LIBS = -lDriverApi -lPciApi -ldl -lpci -lz -lboost_system -lDriverIwarpApi -lJtagAccess -lHmcDebug 

SOURCES = 	HmcDebugCli.cpp 

HFILES = HmcDebugCli.h
OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files
CPPFLAGS = $(WXCXXFLAGS) $(INCLUDES) $(DEFINES) -Wall -g
CC = g++
SUDO = sudo

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

vpath %.so ../../../api/lib ../hmc_debug_lib/lib ../../../pci/api/src ../../../jtagAccess/src

all: $(PROGRAM)

$(PROGRAM): $(HFILES) $(OBJECTS) libHmcDebug.so libDriverIwarpApi.so libDriverApi.so libPciApi.so libJtagAccess.so
	$(CC) $(WXCXXFLAGS) -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS) $(LDLIBS)


libDriverIwarpApi.so:
	$(MAKE) -C ../../../api/iwarp/src lib

libDriverApi.so:
	$(MAKE) -C ../../../api/src lib

libPciApi.so:
	$(MAKE) -C ../../../pci/api/src

libJtagAccess.so:
	$(MAKE) -C ../../../jtagAccess/src

libHmcDebug.so:
	$(MAKE) -C ../hmc_debug_lib/src

install:
	$(SUDO) install -d $(DESTDIR)/usr/bin
	$(SUDO) install -m 0755 hmcDebugCli $(DESTDIR)/usr/bin

clean:
	rm -f $(OBJECTS) $(EXE) $(includes) *.a *.so

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
        $(CC) $(CPPFLAGS) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
