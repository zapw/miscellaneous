FLAGS = -g -c -Wall
LIBS = -ldl -lcppunit -lpci -lz -lboost_system -lrt -lxerces-c
LIB_DIR = -L/usr/local/lib -L../../api/lib/

INCLUDE_DIR = -I../inc -I/usr/local/include  -I/usr/include/sv_driver/api/ -I/usr/include/sv_driver/api/iwarp \
	-I/usr/include/services/Utilities -I/usr/include/services/DescriptorFields  -I/usr/include/services/XMLParsers

CPPFLAGS := $(INCLUDE_DIR)

CPPS := $(wildcard *.cpp)
OBJS := $(CPPS:.cpp=.o)
TEST_OBJECT = $(patsubst %.cpp,%.o,$(wildcard ../../tests/src/*.cpp))

CXXFLAGS := $(INCLUDE_DIR) $(FLAGS) $(DBG)

.PHONY: ../../tests/src clean all default

targets := ../../bin/all.test
../../bin/all.test_preq := -lDriverApi -lDriverIwarpApi -lPciApi -lJtagAccess -lUtilities -lDescriptorFields -lXMLParsers RCF.o

all: default

default: ../../bin/all.test

include ../../../../preq.mk

lib_inc += $(INCLUDE_DIR)
CPPFLAGS += $(lib_inc)

../../bin/all.test: $(OBJS) $(TEST_OBJECT)
	$(CXX) $(CPPFLAGS) -o ../../bin/all.test $(FLAGS) $(OBJS) $(TEST_OBJECT) $(LIBS) $(LDFLAGS) $(LDLIBS) 

$(TEST_OBJECT): | ../../tests/src ;

../../tests/src:
	$(MAKE) -C ../../tests/src

clean:
	rm -rf $(includes) rm -rf ./*.o ../../bin/*.o ../../bin/*.test ../../bin/Results.xml ../../bin/regressionSummary_nightly_format

sources := $(CPPS)

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
	$(CXX) $(lib_inc) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
