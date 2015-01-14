###############################################################
#                                                             #
#  Makefile for Bit Converter				      #
#                                                             #
###############################################################

.DELETE_ON_ERROR:
PROGRAM = bitconv
EXE = $(PROGRAM)
PROGRAM64 = bitconv64
EXE1 = $(PROGRAM64)
WXCONFIG = wx-config
WXCXXFLAGS = `$(WXCONFIG) --cxxflags`
WXLIBS = `$(WXCONFIG) --libs`

INCLUDES = 

LIBDIRS = 

LIBS =
#LIBS = -L ./libtecla -ltecla  -L/usr/lib -ldl  -dynamic -L../../api/lib/ -lDriverApi
#LIBS = $(LIBDIRS) -ltecla -L~rchen7-l/nevada/sv_driver/api/lib  -lDriverApi -ldl  


SOURCES = 	BitConvMain.cpp\
		BitConverterFlex.cpp

SOURCES64 = 	BitConvMain64.cpp\
		BitConverter64.cpp
		
HFILES = 	BitConverterFlex.h

HFILES64 =	BitConverter64.h
		
OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files

OBJECTS64 = $(SOURCES64:.cpp=.o)

CPPFLAGS = $(WXCXXFLAGS) $(INCLUDES) -Wall -g
CC = g++

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)



all: $(PROGRAM) $(PROGRAM64)


$(PROGRAM): $(HFILES) $(OBJECTS)
	$(CC) $(WXCXXFLAGS) -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS)

$(PROGRAM64): $(HFILES64) $(OBJECTS64)
	$(CC) $(WXCXXFLAGS) -o $@ $(OBJECTS64) $(INCLUDES) $(LDFLAGS)

install:
	sudo cp bitconv /usr/bin
	sudo cp bitconv64 /usr/bin

clean:
	$(RM) -f $(OBJECTS) $(OBJECTS64) $(EXE) $(EXE1) $(includes)

run:
	./$(PROGRAM)


sources = $(SOURCES) $(SOURCES64)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

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
