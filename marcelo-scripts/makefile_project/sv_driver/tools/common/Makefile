.DELETE_ON_ERROR:

sources = DriverEvents.cpp PacketCollector.cpp
CPPFLAGS += -I../../api/inc

.PHONY: all clean

all: $(sources:.cpp=.o)

clean:
	rm -f $(sources:.cpp=.o) $(call includes,$(sources))

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#prefix source files names with a dot "." and add ".d" suffix
define includes
$(foreach src,$(1),$(dir $(src)).$(notdir $(src)).d)
endef

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(CPPFLAGS) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
goals = $(patsubst %.o,%.cpp,$(filter %.o,$(MAKECMDGOALS)))
ifneq ($(MAKECMDGOALS), clean)
 ifeq ($(filter all,$(MAKECMDGOALS)), all)
  -include $(call includes,$(sources))
 else ifeq ($(MAKECMDGOALS), )
   -include $(call includes,$(sources))
 else ifneq ($(goals), )
   -include $(call includes,$(goals))
 endif
endif
