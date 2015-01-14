objects := $(patsubst %.cpp,%.o,$(wildcard pktgen_lib/src/*.cpp))

ifdef SVOS
DESTDIR ?= /
endif

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

INC_DIR_LOCAL := pktgen_lib/inc/

CXXFLAGS := -fPIC -Wall -I$(INC_DIR_LOCAL) -fvisibility=hidden

.PHONY: default all remove install
default: all

all:  bin/libpktgen.a bin/libpktgen.so

bin/libpktgen.a: $(objects)
	ar rcs $@ $(objects)

bin/libpktgen.so: $(objects)
	$(CXX) -shared -o $@ $(objects)

clean: remove

remove:
	rm -f $(objects) bin/libpktgen.a bin/libpktgen.so bin/pktgen_test $(includes)

install: ;
sources := $(objects:.o=.cpp)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;

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
	$(CXX) -I$(INC_DIR_LOCAL) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file if goals are not only clean and/or clean_lib
ifneq ($(MAKECMDGOALS),)
ifneq ($(filter-out clean clean_lib install,$(MAKECMDGOALS)),)
-include $(includes)
endif
else
-include $(includes)
endif
