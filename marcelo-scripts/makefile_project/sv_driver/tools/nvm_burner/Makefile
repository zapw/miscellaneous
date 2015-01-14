###############################################################
#											                                                                   #
#  Makefile for nvm_burner
#                                                           												  #
###############################################################

.DELETE_ON_ERROR:
.ONESHELL:
PROGRAM = nvm_burner
EXE = $(PROGRAM)
JAVA_HOME=$(shell readlink -f /usr/bin/javac | sed "s:bin/javac::")

TARGET_SO = lib$(PROGRAM).so

ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif

INCLUDES = \
	-I./inc\
	-I../../api/inc\
	-I./cli\
	-I./impl\
	-I.\
	-I/usr/include/sv_driver/api\
	-I/usr/include/services/RegisterFields\
	-I/usr/include/services/Utilities\
	-I$(JAVA_HOME)/include\
	-I $(JAVA_HOME)/include/linux\
	-I/usr/include/fpga_access

	


LIBDIRS = -L../../api/lib

LIBS = -lDriverApi -lFpgaRegisterAccessApi -lRegisterFields -lUtilities -ldl  -lz -lboost_system -lDriverIwarpApi 

SOURCES_FOR_LIB =	impl/CBaseNVMImageReader.cpp \
					impl/CBaseNVMImageWriter.cpp \
			impl/CBinaryNVMImageReader.cpp \
			impl/CBinaryNVMImageWriter.cpp \
			impl/CBaseNVMBurner.cpp \
			impl/CFWNVMBurner.cpp\
			impl/CMNGSB_NVMBurner.cpp\
			impl/CJProgNVMBurner.cpp\
			INVMBurnerAPI.cpp\
			impl/CNVMBurnerFactory.cpp\
			impl/CNVMBurnerImpl.cpp\
			impl/CError.cpp

SOURCES= 	$(SOURCES_FOR_LIB)\
		cli/CMainApp.cpp \
		cli/nvm_burner.cpp \


OBJECTS_FOR_LIB = $(SOURCES_FOR_LIB:.cpp=.o)  # expands to list of object files

OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files


CPPFLAGS = $(USERDEFINES) $(INCLUDES) $(DEFINES) -Wall -g -fPIC
CC = g++

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

all: $(PROGRAM) $(TARGET_SO)

vpath %.so ../../api/lib
$(PROGRAM): $(OBJECTS) libDriverIwarpApi.so libDriverApi.so
	$(CC)  -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS)

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

$(TARGET_SO): $(OBJECTS)
	$(CC) $(LIBS)  -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO) $(OBJECTS_FOR_LIB)

install:
	sudo cp nvm_burner /usr/bin
	sudo mkdir -p /usr/include/$(PROGRAM)/
	sudo cp *.h /usr/include/$(PROGRAM)/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)

clean:
	$(RM) -f $(OBJECTS) $(EXE) $(TARGET_SO)* cli/*.o impl/*.o $(includes)

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
