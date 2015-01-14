CXXFLAGS := -std=c++0x -Wall -Werror -ggdb
SRCDIR :=src
OBJDIR :=obj
INCDIR :=inc
LIBDIR :=lib
PROD := libdriverutestutils.a
INC := -I$(INCDIR)
CXXFLAGS += $(INC)
SRCS := $(wildcard $(SRCDIR)/*.cpp)
OBJS := $(patsubst $(SRCDIR)/%.cpp,$(OBJDIR)/%.o, $(SRCS))

.PHONY: clean

$(LIBDIR)/$(PROD): $(OBJS)
	ar rvs $@ $(OBJS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp | $(OBJDIR) $(LIBDIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJDIR):
	-mkdir -p $(OBJDIR)

$(LIBDIR):
	-mkdir -p $(LIBDIR)
clean:
	rm -rf  $(OBJDIR) $(LIBDIR) $(includes)

sources := $(SRCS)
#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;

.DELETE_ON_ERROR:
#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template =
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CXX) $(INC) -MT '$(patsubst $(SRCDIR)/%$(suffix $<),$(OBJDIR)/%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file if goals are not only clean and/or clean_lib
ifneq ($(MAKECMDGOALS),)
ifneq ($(filter-out clean clean_lib,$(MAKECMDGOALS)),)
-include $(includes)
endif
else
-include $(includes)
endif
