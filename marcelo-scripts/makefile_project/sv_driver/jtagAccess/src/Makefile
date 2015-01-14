.DELETE_ON_ERROR:
# add GUI support - wx-widgets:
# following lines automatically detect latest wx-widgets package installed 
# and includes the correct flags / libraries in the build comands
WXCXXFLAGS = $(shell wx-config --cxxflags)
WXLIBS = $(shell wx-config --libs)

DEPENDENCY_LIBS = 
INCLUDE_DIR = -I ../inc  -I .  -I ../ftcjtag
LIBS = -lftcjtag -lboost_system
TARGET_SO=libJtagAccess.so
INC_DIR = /usr/include/services/jtagaccess/

ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif

CDBG_FLAGS = -rdynamic -ggdb
CFLAGS = $(CDBG_FLAGS)  -c -Wall -Werror -fpic
CXX = g++

 
# Note: main.cpp is purposely not included in this list
SOURCES = \
	JtagAccess.cpp \
	JtagAccessTwinville.cpp \
	JtagAccessOdem.cpp \
	JtagAccessWrapper.cpp
	

OBJECTS = $(SOURCES:.cpp=.o)

.PHONY: all default
all: default

default: $(TARGET_SO)

#rule for libLiClient library
$(TARGET_SO): $(OBJECTS)
	$(CXX) -shared  $(OBJECTS) -o $(TARGET_SO) $(LIB_DIR) $(LIBS) -lm

#rule for all *.cpp files
.cpp.o:
	$(CXX) $(WXCXXFLAGS) $(INCLUDE_DIR) $(CFLAGS)  $< -o $@

install:
	@echo $(LIBS_DIR)
	sudo mkdir -p $(INC_DIR)
	sudo cp ../inc/*.h $(INC_DIR)
	sudo cp $(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
	
remove_sio_drivers:
	-sudo rmmod ftdi_sio
	-sudo rmmod usbserial

clean:
	rm -rf  *.d $(TARGET_SO) *.o *.a $(includes)
	sudo rm -Rf $(INC_DIR)

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
	$(CC) $(INCLUDE_DIR) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
