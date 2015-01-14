.DELETE_ON_ERROR:

sources = ./libhmcdebugbase/HMCBaseLib.cpp\
        ./libhmcdebug/HMCDebug.cpp\
        ./HMCTest/HMCTest.cpp

libpaths = ../../../api/lib ../../../api/iwarp/lib ../../../pci/api/src ./Debug

INCLUDES = -I../../../api/inc\
        -I../../../api/iwarp/inc\
	-I../../.././tools/hmc_manager/libhmcdebug\
	-I/usr/include/sv_driver/api\
	-I/usr/include/sv_driver/api/iwarp\


LIBDIRS = -L/usr/local/lib\
	  $(libpaths:%=-L%)



LIBS = -lDriverApi -lDriverIwarpApi -lboost_system -lPciApi -ldl -lpci -lz 


CPPFLAGS =$(INCLUDES) $(DEFINES) $(GENERAL_DEFINES) -Wall -fpic
SWIGFLAGS=$(INCLUDES) $(DEFINES) -Wall
CC = g++

ifeq ($(shell cat /etc/redhat-release), Laughlin)
@echo UUUUU
endif

#SOURCES = \
#	../../common/SvdtLib.cpp\
#	../../common/SvdtPacketCollectorPcap.cpp\
#	$(SOURCES_NEVADA)

#OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files

nullstring :=

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) -Wl,-rpath=$(subst $(nullstring) ,:,$(libpaths))

vpath %.so $(libpaths)
vpath %.o ./Debug

ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
CPPFLAGS += -DX86_64 -g
else
LIBS_DIR = /usr/lib
endif

HMCBASELIB = ./Debug/libhmcdebugbase.so
HMCDEBUG = ./Debug/libhmcdebug.so

.PHONY: all Debug install_hmc_base_lib install_hmc_debug install_hmc_flows clean Debug

all: ./Debug/HMCTest

Debug:
	-mkdir Debug

$(HMCBASELIB): HMCBaseLib.o libDriverIwarpApi.so libDriverApi.so libPciApi.so | Debug
	$(CC)  -shared -o $(HMCBASELIB) ./Debug/$(<F) $(CPPFLAGS) $(LDFLAGS)

HMCBaseLib.o: | Debug
	$(CC) -fpic -c ./libhmcdebugbase/HMCBaseLib.cpp -o ./Debug/$(@F) $(CPPFLAGS)

	
$(HMCDEBUG): HMCDebug.o $(HMCBASELIB) | Debug
	$(CC) -shared -o $(HMCDEBUG) -lhmcdebugbase ./Debug/$(<F) $(CPPFLAGS)  $(LDFLAGS)

HMCDebug.o: | Debug
	$(CC) -fpic -c ./libhmcdebug/HMCDebug.cpp -o ./Debug/$(@F)  $(CPPFLAGS)

./Debug/HMCTest: HMCTest.o $(HMCBASELIB) $(HMCDEBUG) | Debug
	$(CC)  -o ./Debug/HMCTest  ./Debug/HMCTest.o -lhmcdebugbase -lhmcdebug  

HMCTest.o: | Debug
	$(CC) -fpic -c ./HMCTest/HMCTest.cpp  -o ./Debug/HMCTest.o $(CPPFLAGS) 


install: install_hmc_base_lib install_hmc_debug
	sudo cp Debug/HMCManager /usr/bin/
	sudo /sbin/ldconfig

install_hmc_base_lib:
	sudo cp $(HMCBASELIB) $(LIBS_DIR)

install_hmc_debug:
	@echo $(LIBS_DIR)
	sudo cp $(HMCDEBUG) $(LIBS_DIR)

clean:
	rm -rf ./*.so ./*.o ./Debug $(includes)


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
