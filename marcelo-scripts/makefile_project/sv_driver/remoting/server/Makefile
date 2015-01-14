.DELETE_ON_ERROR:
###############################################################
#                                                             #
#      Makefile for remoting server application               #
#                                                             #
###############################################################

PROGRAM = remoting-server


INCLUDES = \
	-I../../api/inc\
	-I../../api/iwarp/inc\
	-I../Rcf/include\
	-I../../i200e/shared\
	-I../../i40e/shared

LIBDIRS = -L../../api/lib


LIBS = -lDriverApi -lDriverIwarpApi -ldl -lpci -lboost_system -lpthread


SOURCES = 	RemotingServer.cpp\
		Remoter.cpp\
		
		
		
HFILES =	RemotingServer.h\
		Remoter.h
	
vpath %.so ../../api/lib

OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files
CPPFLAGS = $(INCLUDES) -Wall -g -DRCF_USE_BOOST_ASIO -Wno-deprecated
CC = g++ -DRCF_USE_BOOST_ASIO
LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS)

$(PROGRAM): $(HFILES) $(OBJECTS) libDriverIwarpApi.so libDriverApi.so | ../Rcf
	$(CC) -o $@ $(OBJECTS) $(DBG) $(INCLUDES) $(LDFLAGS) $(LDLIBS)

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp/src lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

../Rcf:
	$(MAKE) -C ../ $@

install: kill
	sudo cp $(PROGRAM) /usr/bin

# before installing, make sure remoting server is not running
# to prevent possible segmentation fault
# the lock file is used by the remoting server and if it exists
# there is a good change it is currently running
# therefore we kill it before installing
kill:
	-if test -e /tmp/sv_driver_remoting_server_lock_file;\
		then sudo killall -9 $(PROGRAM); sleep 1;\
	fi

clean:
	$(RM) -f $(OBJECTS) $(PROGRAM) $(includes)

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
%.d: $$(call template,$$(@D),$$(*F)) | ../Rcf
	$(CC) $(CPPFLAGS) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
