.DELETE_ON_ERROR:
CXXFLAGS := -g -c -Wall# -Werror
INCLUDE_DIR = -I../inc  -I/usr/local/include  -I/usr/include/sv_driver/api/ -I../../api/inc -I../../pci/api/inc \
	-I../../jtagAccess/inc -I../../api/iwarp/inc -I/usr/include/sv_driver/api/iwarp \
	-I/usr/include/services/Utilities -I/usr/include/services/DescriptorFields  -I/usr/include/services/XMLParsers
OBJS := $(patsubst %.cpp,%.o,$(sort $(wildcard *.cpp)))
CPPS := $(wildcard *.cpp)

set_inc := -lDriverApi -lDriverIwarpApi -lPciApi -lJtagAccess -lUtilities -lDescriptorFields -lXMLParsers


CXXFLAGS += $(lib_inc) $(INCLUDE_DIR)

all: default

include ../../../../preq.mk
default: $(OBJS)

clean:
	rm -f $(includes) ./*.o

sources = $(wildcard *.cpp)

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
	$(CXX) $(INCLUDE_DIR) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
