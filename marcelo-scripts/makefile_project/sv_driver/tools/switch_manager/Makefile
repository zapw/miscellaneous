
.DELETE_ON_ERROR:
PROGRAM_B = DebugDump
PROGRAM_A = GetMetaData

INCLUDES = -I../../../sv_driver/api/inc/

LIBDIRS = -L../../api/lib
LIBS = -ldl -lDriverApi  -lboost_system -lDriverIwarpApi


SOURCES_B = 	DebugDump.cpp
SOURCES_A =     GetMetaData.cpp

			
OBJECTS_B = $(SOURCES_B:.cpp=.o)  # expands to list of object files
OBJECTS_A = $(SOURCES_A:.cpp=.o)  # expands to list of object files

CPPFLAGS = $(INCLUDES) -Wall -g
CC = g++

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) 


all: $(PROGRAM_B) $(PROGRAM_A)
	cd  SwitchManager && ./LinBuilder.sh && mv SwitchManager.jar .. &&  cd ..

vpath %.so ../../api/lib	
$(PROGRAM_A) $(PROGRAM_B): %: %.o libDriverIwarpApi.so libDriverApi.so
	$(CC) -o $@ $< $(INCLUDES) $(LDFLAGS) $(LDLIBS)
	

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp/src lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

clean:
	$(RM) -f SwitchManager.jar SwitchManager/SwitchManager.jar $(includes)

	$(RM) -f $(OBJECTS_A) $(PROGRAM_A) *.d
	$(RM) -f $(OBJECTS_B) $(PROGRAM_B) *.d

	$(RM) ../$(PROGRAM_A)
	$(RM) ../$(PROGRAM_B)


install:
	cp $(PROGRAM_B) ../
	cp $(PROGRAM_A) ../


sources = $(SOURCES_A) $(SOURCES_B)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile) called .name.cpp.d from a C++ source file called name.cpp:

#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

%.d: $$(call template,$$(@D),$$(*F))
        $(CC) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
