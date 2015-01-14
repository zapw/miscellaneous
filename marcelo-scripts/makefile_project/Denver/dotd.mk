define auto_prerequisite_gen
#prefix source files names with a dot "." and add ".d" suffix
includes = $$(foreach src,$$(sources),$$(dir $$(src)).$$(notdir $$(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$$(1)/$$(patsubst .%,%,$$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):

%.d: $$$$(call template,$$$$(@D),$$$$(*F))
	$$(CXX) $$(CXXFLAGS) $$(all_lib_inc) -MT '$$(patsubst %$$(suffix $$<),%.o,$$<)' -MT '$$@' -MM $$< > $$@

#Include ".d" makefiles file if goals are not only clean and/or clean_lib
ifneq ($$(MAKECMDGOALS),)
ifneq ($$(filter-out clean clean_% clean-% install install-% install_%,$$(MAKECMDGOALS)),)
-include $$(includes)
endif
else
-include $$(includes)
endif
endef
