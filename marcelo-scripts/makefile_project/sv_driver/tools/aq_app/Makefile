.DELETE_ON_ERROR:
PROGRAM := gaq
EXE := $(PROGRAM)

WXCONFIG := wx-config
WXCXXFLAGS := $(shell $(WXCONFIG) --cxxflags)
WXLIBS := $(shell $(WXCONFIG) --libs)

INCLUDES := \
	-I./inc\
	-I../../api/inc\
	-I/usr/include/sv_driver/api\

LIBDIRS := -L../../api/lib

LIBS := -lDriverApi -lDriverIwarpApi -ldl -lpci -lboost_system

SOURCES = 	AdminQueueDialogs.cpp\
		AdminQueueDialogsBackEnd.cpp\
		AdminQueueTestApp.cpp\
		DataDisplay.cpp\
		DriverConnector.cpp\
		Gaq.cpp\
		GaqCliI40e.cpp\
		GaqCliI200e.cpp\

OBJECTS := $(SOURCES:.cpp=.o)  # expands to list of object files
CPPFLAGS := $(WXCXXFLAGS) $(INCLUDES) $(DEFINES) -Wall -g -DSV_DRIVER
#CPPFLAGS += -DFVL_25 # to compile with register addresses from FVL WW25 (AFC) model
CPPFLAGS += -DFVL_L0 # to compile with register addresses from FVL WW38 (L0) model
#CPPFLAGS += -DGAQ_DEBUG # to allow GUI testing without underlying device

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

LDFLAGS := -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

.PHONY: default debug all

debug: CPPFLAGS += -DGAQ_DEBUG
default debug: all

all: $(PROGRAM)

vpath %.so ../../api/lib
$(PROGRAM): $(HFILES) $(OBJECTS) libDriverIwarpApi.so libDriverApi.so
	$(CXX) $(WXCXXFLAGS) -o $@ $(OBJECTS) $(INCLUDES) $(LDFLAGS)

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

install:
	sudo cp gaq /usr/bin

clean:
	$(RM) -f $(OBJECTS) $(EXE) $(includes)

run:
	./$(PROGRAM)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
	
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
	$(CXX) $(WXCXXFLAGS) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
