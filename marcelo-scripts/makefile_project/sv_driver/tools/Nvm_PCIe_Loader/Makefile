###############################################################
#											                                                                   #
#  Makefile for GSVDT (Graphical version of sv driver tool)								   #
#                                                           												  #
###############################################################

.DELETE_ON_ERROR:
PROGRAM = NVM-PCIe-Loader
EXE = $(PROGRAM)


INCLUDES = \
	-I./inc\
	-I../../api/inc\
	-I/usr/include/sv_driver/api

	


LIBDIRS = -L../../api/lib

LIBS = -lDriverApi  -ldl  -lz -lboost_system -lDriverIwarpApi 

SOURCES = 	      	CGL_burner.cpp \
			CFVL_burner.cpp \
			flashburn.cpp \


OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files

#USERDEFINES = -DDEBUG
CPPFLAGS = $(USERDEFINES) $(INCLUDES) $(DEFINES) -Wall -g
CC = g++

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

all: $(PROGRAM)

vpath %.so ../../api/lib
$(PROGRAM): $(OBJECTS) libDriverIwarpApi.so libDriverApi.so
	$(CC)  -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS)

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

install:
	sudo cp NVM-PCIe-Loader /usr/bin

clean:
	$(RM) -f $(OBJECTS) $(EXE) $(includes)

run:
	./$(PROGRAM)

rebuild: clean all


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
	$(CC) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif

