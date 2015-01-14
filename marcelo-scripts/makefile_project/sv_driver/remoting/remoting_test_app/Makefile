.DELETE_ON_ERROR:
###############################################################
#											                                                                   #
#  Makefile for remoting test app			      #
#                                                           												  #
###############################################################

PROGRAM = remoting_test_app


INCLUDES = \
	-I./inc\
	-I../../api/inc\
	-I../../api/iwarp/inc\
	-I/usr/include/services/DescriptorFields\
	-I/usr/include/services/OnRingElements\
	-I/usr/include/sv_driver/api

LIBDIRS = -L../../api/lib

LIBS = -lDriverApi -lDriverIwarpApi -ldl -lpci -lz -lboost_system

SOURCES = 	RemotingTestApp.cpp
		
OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files
CPPFLAGS = $(WXCXXFLAGS) $(INCLUDES) $(DEFINES) -Wall -g
CC = g++

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

vpath %.so ../../api/lib

$(PROGRAM): $(HFILES) $(OBJECTS) libDriverIwarpApi.so libDriverApi.so
	$(CC) $(WXCXXFLAGS) -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS) $(LDLIBS)


libDriverApi.so:
	$(MAKE) -C ../../api/src lib

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp/src lib


clean:
	rm -f $(PROGRAM) $(includes) $(OBJECTS)

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
	$(CC)  $(WXCXXFLAGS) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
