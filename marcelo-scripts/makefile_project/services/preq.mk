#The main purpose of this file is for resolving library prerequisites recursively in order to have all dependencies compiled, if needed, before the final TARGET.

# targets_so := 
#       list of target libraries the designated Makefile ( the one that is including this file ) wants to create. this can be *any* desired name ( libSomeName.so|libSomeName.a|FunkyName ).
#	Exception to the rule above is for libraries that ARE already defined in this preq.mk file, per example: -lSyntheticTest -lEvents, in this case
#	one must use the -lNAME form
# Example:
#	targets_so := -lSyntheticTest -lEvents ...	
#
#	it is possible to combine different names
#		targets_so := lSyntheticTest -lEvents libSomeName.so FunkyName 
	
# targets := 
#        could be any target name that is not going to be used as a library
#	 usually executables to create.
# Example:
#	targets := testprogram tesrprogram1 ...

# TARGET_preq := 
#        a lists of library prerequisites required by a TARGET where TARGET is the *full* name of a library OR target previously defined in 'targets' or 'targets_so' variable.
# Example:
# 	 -lSyntheticTest_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
#	 -lEvents_preq := -lUtilities
#	 libSomeName.so_preq := -lUtilities -lDescriptorFields
#	 libSomeName.a_preq := -lUtilities -lDescriptorFields
#	 FunkyName_preq := -lUtilities -lXMLParsers
# 	
# targets_so_preq := 
# In case all libraries defined in 'targets_so' share the same list of prerequisites one can use this variable instead of repeating the list for each library with TARGET_preq.
# Example:
# 	targets_so := -lSyntheticTest -lEvents libSomeName.so libSomeName.a FunkyName
# 	targets_so_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
#
# 	Instead of writing:
# 	 -lSyntheticTest_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
#	 -lEvents_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
#	 libSomeName.so_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
#	 libSomeName.a_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
#	 FunkyName_preq := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements

# *NOTE* that writing TARGET_preq will always override the list defined in 'targets_so_preq' for TARGET.

# targets_preq := 
#        Similar to 'targets_so_preq' instead of writting 'TARGET_preq' for each TARGET one can use this variable to list prerequisites shared among all targets defined in the variable 'targets'.
#        The difference between 'targets_preq' and 'targets_so_preq' is that 'targets_preq' will inspect 'targets' while 'targets_so_preq' will inspect 'targets_so'
#        in addition 'targets_so'/'targets_so_preq' will not populate 'CPPFLAGS'
#
# *NOTE* that writing 'TARGET_preq' will always override the list defined in 'targets_preq' for TARGET.
# if neither 'TARGET_preq' nor 'targets_so_preq' is defined, it will try and look for a variable named 'TARGET_rpathlink' in this file (preq.mk) and if found will use its value.
#

#After preq.mk is done reading 'targets_so', 'targets' and later 'targets_so_preq','targets_preq' and 'TARGET_preq';
# each target (library/executable) defined in 'targets' or 'targets_so' will have a PRIVATE copy of the variables CPPFLAGS, LDFLAGS and LDLIBS.
# these variables can later be used inside a recipe for that target. per example:
#
# targets_so := -lHMCFields
# targets := sometest
#
# -lHMCFields_preq := -lUtilities
# sometest_preq := -lUtilities -lHMCFields
#
# -lHMCFields: $(objects)
#	$(CXX) -shared -Wl,-soname,libUtilities.so -o libUtilities.so.0.0 $(objects) $(LDFLAGS) $(LDLIBS)
#	/sbin/ldconfig -n libUtilities.so.0.0
#
# sometest: someobject.o
#	$(CXX) $(CPPFLAGS) -o sometest someobject.o $(LDFLAGS) $(LDLIBS)

# What's inside 'CPPFLAGS', 'LDFLAGS' and 'LDLIBS'.
# 'CPPFLAGS' will have ALL the include directories relative to the directory where make is being executed that attribute to the libraries specified in 'TARGET_preq' or if 'TARGET'_preq was not defined and TARGET is not a library and was defined in 'targets' it will inspect 'targets_preq' instead.
#
# Example:
# 	'CPPFLAGS' in the recipe "$(CXX) $(CPPFLAGS) -o sometest someobject.o $(LDFLAGS) $(LDLIBS)" will contain "-IRELATIVE_PATH/Utilities/inc "-IRELATIVE_PATH/HMCFields/inc"
# 		Where RELATIVE_PATH is the relative path from where the current executing make included this file (preq.mk), per example ../../../
#
# 'LDFLAGS' same as 'CPPFLAGS' except instead of include directories and having the flag "-I" prefixed to them, it will contain directories where libraries are eventually saved to during compilation with the flag "-L" prefixed to them and with the addition of inspecting 'targets_so_preq' in case 'TARGET_preq' is not defined and TARGET appears in 'targets_so'.
#
# Furthermore, in addition to prefixing directories with "-L", "-Wl,-rpath=" is also saved in 'LDFLAGS' prefixed with the list of the directories separated by colon ":".
#
# Example:
# 	In the recipe "$(CXX) $(CPPFLAGS) -o sometest someobject.o $(LDFLAGS) $(LDLIBS)",
#
# 	 Where, 'targets' := sometest and sometest_preq := -lUtilities -lHMCFields
#
# 		'LDFLAGS' will contain "-LRELATIVE_PATH/Utilities -LRELATIVE_PATH/HMCFields -Wl,-rpath=RELATIVE_PATH/Utilities:RELATIVE_PATH/HMCFields"
#
# 	where as 'LDFLAGS' in the recipie "$(CXX) -shared -Wl,-soname,libUtilities.so -o libUtilities.so.0.0 $(objects) $(LDFLAGS) $(LDLIBS)"  for the target '-lHMCFields' and targets_so := -lHMCFields
#
# 	will contain just "-LRELATIVE_PATH/Utilities -Wl,-rpath=RELATIVE_PATH/Utilities".
#
# 'LDLIBS' same as 'LDFLAGS' except instead of containing path names prefixed with "-L" it will contain the name of the libraries in the form -lNAME
#
# Example:
# 	'LDLIBS' in the recipe "$(CXX) $(CPPFLAGS) -o sometest someobject.o $(LDFLAGS) $(LDLIBS)" will contain "-lUtilities -lHMCFields"
# 	 where as 'LDLIBS' in the recipie "$(CXX) -shared -Wl,-soname,libUtilities.so -o libUtilities.so.0.0 $(objects) $(LDFLAGS) $(LDLIBS)" for the target '-lHMCFields',
# 	 will contain just "-lUtilities"

#There are cases where one needs only the include directories for a service library or libraries, to later be used in a custom special target. This can be done with the variable 'set_inc'.
# set_inc := 
#        This variable accepts names of service libraries in the form -lNAME it will try and look for a variable matching the name -lNAME_incpath in this file (preq.mk)
#        if found another variable named 'lib_inc' will have ALL the include directories attributed to that library relative to the directory where make included this file
# Example:
# 	set_inc := -lPacketGeneratorI -lUtilities
# 	will then define 'lib_inc' with the value:
#
# 	"-IRELATIVE_PATH/PacketGeneratorI/IPackets/inc -IRELATIVE_PATH/PacketGeneratorI/Utilities/inc -IRELATIVE_PATH/PacketGeneratorI/Payload/inc -IRELATIVE_PATH/PacketGeneratorI/ILayers/inc -IRELATIVE_PATH/PacketGeneratorI/IFactory/inc -IRELATIVE_PATH/Utilities/inc"
# 	Where RELATIVE_PATH is the relative path from where the current executing make included this file (preq.mk), per example ../../../
#
# this can later be used in a custom rule
#
# Example:
# 	set_inc := -lUtilities
# 	mysourcefile.o: mysourcefile.cpp
# 		$(CXX) $(lib_inc) -Isomeotherpath/inc -o mysourcefile.o mysourcefile.cpp
# 	'lib_inc' will contain "-IRELATIVE_PATH/Utilities/inc",
#
# 	Where RELATIVE_PATH is the relative path from where the current executing make included this file (preq.mk), per example ../../../

# Implicit rules, CXXFLAGS and CPPFLAGS.
# Altought it's possible to use 'lib_inc' like mentioned above with explicit rules for creating object files, the current way to compile object files from source files is by using make's
# Built-in implicit rule:
#
# %.o: %.cpp
#	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@
#
# what is left is set the variables 'CXXFLAGS' and 'CPPFLAGS', 'CXX' by default is 'g++'
# in order to avoid having to manually write down every include path required to compile objects files from source, preq.mk scans the variables 'targets_so','targets_so_preq' and any 'TARGET_preq' for a name matching  -lNAME_incpath in this file (preq.mk)
# where -lNAME is any of the libraries in 'targets_so','targets_so_preq' or 'TARGET_preq'.
#
# the result is saved under the variable 'all_lib_inc'.
#
# all_lib_inc is saved to CPPFLAGS as target specifc variable like this:
#
# %.o: CPPFLAGS := $(strip $(CPPFLAGS) $(all_lib_inc))
#
# this means all files ending with .o suffix will have their CPPFLAGS set to all the includes files from all 'targets_so', their prerequisits and any other prerequisits from 'targets'.
# 
# Example:
#
# 	targets_so := lSyntheticTest -lScapyPacketGenerator
# 	targets := sometest_executable someothertest_executable
#
# 	sometest_executable_preq := -lIxia
#
# will first have the variable 'all_lib_inc' set with the value:
# -IRELATIVE_PATH/SyntheticTest/inc -IRELATIVE_PATH/ScapyPacketGenerator/PythonServices/inc -IRELATIVE_PATH/ScapyFactory/inc -IRELATIVE_PATH/ScapyLayers/inc ScapyPackets/inc -IRELATIVE_PATH/Ixia/inc
#  and then later saved to the variable 'CPPFLAGS' of the implicit target %.o, like this:
#
# %.o: CPPFLAGS := $(strip $(CPPFLAGS) $(all_lib_inc))
#
# 	any previous defined global 'CPPFLAGS' and 'all_lib_inc' variable is appended to the new values of 'CPPFLAGS' and 'all_lib_inc'.
#
# since 'CXXFLAGS' by convention is used for setting custom compiler flags for the the impilict rule above
#
# one should use it to pass flags to the compiler ('CXX' or g++, for the implicit rule mentioned above).
#
# Example:
#
# 	CXXFLAGS := -fPIC -Wall -g
#
# the variable can be shared with explicit rules.
# Example:
#	sometest: someobject.o
# 		$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o sometest someobject.o $(LDFLAGS) $(LDLIBS)
#
# if there are any source files (.cpp) with no explicit rule to compile them, then the implicit rule for %.o will fire up and the compiler flags defined in 'CXXFLAGS' will be used to compile the objects files as well as for the explicit rule for 'sometest' target above.
#
# 
#As said in the title. The main purpose of this file is for resolving library prerequisites recursively in order to have all dependencies compiled, if needed, before the final TARGET.
#Explanation of the above statement:

#Say we want to compile a new library call it "libMyNeatlib.so.0.0" and let's assume that this library depends on libSomeOtherlib.so libSomeOtherlib2.so

#our Makefile will look something like this:

#variables used by implicit '%.o: %.cpp'  rule
#CXXFLAGS := -fPIC -Wall -g
#CPPFLAGS := -I./inc/ -I../../SomeOtherlib/inc -I../../SomeOtherlib2/inc
#
#
#libMyNeatlib.so: source.o source1.o source2.o ../../libSomeOtherlib.so ../../libSomeOtherlib2.so
#	$(CXX) -shared -Wl,-soname,libMyNeatlib.so -o libMyNeatlib.so.0.0 source.o source1.o source2.o -L../../SomeOtherlib/ -L../../SomeOtherlib2/ -lSomeOtherlib -lSomeOtherlib2 -Wl,-rpath=../../SomeOtherlib/:../../SomeOtherlib2/
#	/sbin/ldconfig -n libMyNeatlib.so.0.0

#../../libSomeOtherlib.so:
#	$(MAKE) -C ../../SomeOtherlib/ libSomeOtherlib.so

#../../libSomeOtherlib2.so:
#	$(MAKE) -C ../../SomeOtherlib2/ libSomeOtherlib2.so

#the implicit rule %.o: %.cpp will use the values of CXXFLAGS and CPPFLAGS to compile our object files (source.o, source1.o and source2.o from .cpp source files matching source.cpp, source1.cpp and source2.cpp).

#"../../libSomeOtherlib.so" and "../../libSomeOtherlib2.so" are prerequisites of "libMyNeatlib.so" and they contain the relative path to where to find the libraries they depend on.
#When make scan the Makefile it buils a prerequisites list for each target here being the targets 'libMyNeatlib.so',../../libSomeOtherlib.so and ../../libSomeOtherlib2.so. It then compares the timestamp on the prerequists against the target
#and if the timestamp of any of the prerequisites is newer than the target it knows it must run the recipe for that target.

#let's assume our tree is clean and libSomeOtherlib.so and libSomeOtherlib2.so have not been created yet, when make begins executing the target 'libMyNeatlib.so' it will not find libSomeOtherlib.so and libSomeOtherlib2.so its next step is to try and create these files that are needed by libMyNeatlib.so, it will look for a rule with the targets ../../libSomeOtherlib.so and  ../../libSomeOtherlib2.so

#and if found will run their recipes, in the example above it will run the recipes '$(MAKE) -C ../../SomeOtherlib/ libSomeOtherlib.so' and '$(MAKE) -C ../../SomeOtherlib2/ libSomeOtherlib2.so'
# which says to execute 'make -C ../../SomeOtherlib/ libSomeOtherlib.so' and 'make -C ../../SomeOtherlib2/ libSomeOtherlib2.so'  libSomeOtherlib.so is the name of a 'goal' to look for in the Makefile under '../../libSomeOtherlib' ( a goal can also be thought as a target name )
#
# now imagine libSomeOtherlib.so and libSomeOtherlib2.so by themselves depend on tens of other libs and these libs depend on ten more other libs and so on and on... our Makefile will have to account for ALL of these dependencies in order to compile our final main 'goal' "libMyNeatlib.so"
#
# Now we write the same Makefile using 'preq.mk'
#
#
# targets_so := -lMyNeatlib
# targets_so_preq := -lSomeOtherlib -lSomeOtherlib2
#
# CXXFLAGS := -fPIC -Wall -g
# include ../../../preq.mk
#
# -lMyNeatlib: object.o object1.o object2.o
#  	$(CXX) -shared -Wl,-soname,libMyNeatlib.so -o libMyNeatlib.so.0.0 object.o object1.o $(LDFLAGS) $(LDLIBS)

#And that is all there is. Since preq.mk already has a definition of all known prerequisites of libraries in our services tree there is no need to specify them for the target "-lMyNeatlib:"
#In addition the recipes for calling these prerequisites for compilation are also defined.

#sources :=
#	a list of source files used by the pattern rule "%.d" ( dot .d files )
#
#Example:

#at the end of this file (preq.mk) there is a rule inside a variable definition called 'auto_prerequisite_gen' written like:

#includes = $$(foreach src,$$(sources),$$(dir $$(src)).$$(notdir $$(src)).d)
#...
#...
#...
#%.d: $$$$(call template,$$$$(@D),$$$$(*F))
#	$$(CXX) $$(all_lib_inc) -MT '$$(patsubst %$$(suffix $$<),%.o,$$<)' -MT '$$@' -MM $$< > $$@
#
#-include $$(includes)

#it uses the list defined in the variable 'sources' to generate a list of files named .FILENAME.d where FILENAME is the prefix name of a file named FILENAME.cpp or FILENAME.c etc ...
#the variable 'all_lib_inc' is used for the include paths of where to search for header files required for generating a list of files of prerequisites.

#.FILENAME.d will contain a list of header files read from FILENAME.cpp recursively and FILENAME.cpp itself as prerequisites to FILENAME.o and .FILENAME.d targets.
# Example:
# for the source file CBuffer.cpp a file of prerequisites named .CBuffer.cpp.d will be created with the content:
# CBuffer.o .CBuffer.cpp.d: CBuffer.cpp ../../Utilities/inc/CBuffer.h \
#  ../../Utilities/inc/CError.h ../../Utilities/inc/BasicServices.h \
#  ...
#  ...
# This means whenever any of the listed header files or CBuffer.cpp change, make knows it must recompile the object file, either using an Built-in implicit rule for "%.o" target or an explicit one written in the Makefile.
# It also knows it must remake the file .CBuffer.cpp.d and it will use our "%.d" rule above in order to do so.
#  the result is possibly an updated new list of header files saved to .CBuffer.cpp.d

#to call the definition add this line to a Makefile:
# $(eval $(auto_prerequisite_gen))
#the variable 'includes' will hold the list of the ".FILENAME.d" files which can be used in a clean rule.
# Example:

#clean:
#	rm -f *.o .*.d $(includes)

#shortest-stem was introduced in gnu make 3.82 which also introduced target-specific private variables
ifneq ($(filter shortest-stem,$(.FEATURES)),)
private := private
endif

nullstring :=
space := $(nullstring) #

services_root := $(dir $(lastword $(MAKEFILE_LIST)))

#MAKEFILE_LIST contains a list of all included makefiles thus far.
#so the function below will return the directory relative from where this file was included,
# Example:
# 	if current invocation of make is reading makefile  services/PacketGeneratorI/Makefile and it is has a line 'include ../preq.mk'
# 	services_root will equal to "../"


define -lPacketGeneratorI 
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lScapyPacketGenerator
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lUtilities
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lgUtilities
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lDescriptorFields
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lDescriptorFieldsTcl
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lgDescriptorFields
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lDummyService
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lJdsu
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lRegisterFields
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lRegisterFieldsTcl
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lgRegisterFields
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lOnRingElements
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lPcktDescDBTcl
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lAdminQueue
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lAnue
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lNVMFields
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lHMCFields
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lIxia
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lEvents
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lSyntheticTest
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lIosfFields
	+$(MAKE) -C $(services_root)$(@:-l%=%)/src -- $@
endef
define -lXMLParsers
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $@
endef
define -lCommuneNet
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lLeCroy
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lExecutionEngine
	+$(MAKE) -C $(services_root)$(@:-l%=%) -- $(@)
endef
define -lFpgaRegisterAccessApi
	+$(MAKE) -C $(services_root)FpgaAccess/FpgaAccessApi -- $(@)
endef
define -lftd2xx
	+$(MAKE) -C $(services_root)FpgaAccess/ftdi_driver -- $(@)
endef
define -lDukeProxy
	+$(MAKE) -C $(services_root)FpgaAccess/duke_proxy -- $(@)
endef
define -lgenesys_proxy
	+$(MAKE) -C $(services_root)FpgaAccess/genesys_proxy/src -- $(@)
endef
define -lVeloceProxy
	+$(MAKE) -C $(services_root)FpgaAccess/veloce_proxy -- $(@)
endef
define -lfpga_shared_code
	+$(MAKE) -C $(services_root)FpgaAccess/shared_code -- $(@)
endef

#list number 1
#The list above is used by the pattern rule.
#-l%:
#	$(call $@)

# % is a wildcard, "$(call $@)" will call a variable expanded from -l% and replaced with $@, then return the result of the definition matching the variable name.
# which then will become the recipe for the expanded value of the target -l%.
# Example:
#  -lVeloceProxy
#  	$(call $@)
#
#  will return +$(MAKE) -C $(services_root)FpgaAccess/veloce_proxy -- $(@)
#  $(@) will expand to -lVeloceProxy 
#  "services_root" will expand to the relative directory where this file was included $(MAKE) is a make internal and it's used to communicate with sub invocations of makes.
#
#  so $(MAKE) -C $(services_root)FpgaAccess/veloce_proxy -- -lVeloceProxy
#  	will run make on the directory where FpgaAccess/veloce_proxy is located with the 'goal' "-lVeloceProxy", hopefully VeloceProxy's Makefile in that directory will have
#  	a rule named -lVeloceProxy overriding our -l% pattern rule in this preq.mk file, telling how to create the library for VeloceProxy.

.PHONY: dummygoal
dummygoal: ;

-l%:
	$(call $@)

-lPacketGeneratorI_searchpath := $(services_root)PacketGeneratorI
-lRegisterFields_searchpath := $(services_root)RegisterFields
-lRegisterFieldsTcl_searchpath := $(services_root)RegisterFields
-lgRegisterFields_searchpath := $(services_root)gRegisterFields
-lUtilities_searchpath := $(services_root)Utilities
-lgUtilities_searchpath := $(services_root)gUtilities
-lScapyPacketGenerator_searchpath := $(services_root)ScapyPacketGenerator
-lDescriptorFields_searchpath := $(services_root)DescriptorFields
-lDescriptorFieldsTcl_searchpath := $(services_root)DescriptorFields
-lgDescriptorFields_searchpath := $(services_root)gDescriptorFields
-lDummyService_searchpath := $(services_root)DummyService
-lJdsu_searchpath := $(services_root)Jdsu
-lOnRingElements_searchpath := $(services_root)OnRingElements
-lPcktDescDBTcl_searchpath := $(services_root)OnRingElements
-lAdminQueue_searchpath := $(services_root)AdminQueue
-lAnue_searchpath := $(services_root)Anue
-lNVMFields_searchpath := $(services_root)NVMFields
-lHMCFields_searchpath := $(services_root)HMCFields
-lIxia_searchpath := $(services_root)Ixia
-lEvents_searchpath := $(services_root)Events
-lSyntheticTest_searchpath := $(services_root)SyntheticTest
-lIosfFields_searchpath := $(services_root)IosfFields
-lXMLParsers_searchpath := $(services_root)XMLParsers
-lCommuneNet_searchpath := $(services_root)CommuneNet
-lLeCroy_searchpath := $(services_root)LeCroy
-lExecutionEngine_searchpath := $(services_root)ExecutionEngine
-lFpgaRegisterAccessApi_searchpath := $(services_root)FpgaAccess/FpgaAccessApi
-lftd2xx_searchpath := $(services_root)FpgaAccess/ftdi_driver
-lDukeProxy_searchpath := $(services_root)FpgaAccess/duke_proxy
-lgenesys_proxy_searchpath := $(services_root)FpgaAccess/genesys_proxy/src
-lVeloceProxy_searchpath := $(services_root)FpgaAccess/veloce_proxy
-lfpga_shared_code_searchpath := $(services_root)FpgaAccess/shared_code

#list number 2
#The list above are paths where each service library can be found AFTER compilation/linkage. 

-lPacketGeneratorI_incpath := $(patsubst %,-I$(services_root)PacketGeneratorI/%,IPackets/inc Utilities/inc Payload/inc ILayers/inc IFactory/inc)
-lRegisterFields_incpath := -I$(services_root)RegisterFields/inc
-lRegisterFieldsTcl_incpath := -I$(services_root)RegisterFields/inc
-lgRegisterFields_incpath := -I$(services_root)gRegisterFields/inc
-lUtilities_incpath := -I$(services_root)Utilities/inc
-lgUtilities_incpath := -I$(services_root)gUtilities/inc
-lScapyPacketGenerator_incpath := $(patsubst %,-I$(services_root)ScapyPacketGenerator/%,PythonServices/inc ScapyFactory/inc ScapyLayers/inc ScapyPackets/inc)
-lDescriptorFields_incpath := -I$(services_root)DescriptorFields/inc
-lDescriptorFieldsTcl_incpath := -I$(services_root)DescriptorFields/inc
-lgDescriptorFields_incpath := -I$(services_root)gDescriptorFields/inc
-lDummyService_incpath := -I$(services_root)DummyService/inc
-lJdsu_incpath := -I$(services_root)Jdsu/inc
-lOnRingElements_incpath := -I$(services_root)OnRingElements/inc
-lPcktDescDBTcl_incpath := -I$(services_root)OnRingElements/inc
-lAdminQueue_incpath := -I$(services_root)AdminQueue/inc
-lAnue_incpath := -I$(services_root)Anue/inc
-lNVMFields_incpath := -I$(services_root)NVMFields/inc
-lHMCFields_incpath := -I$(services_root)HMCFields/inc
-lIxia_incpath := -I$(services_root)Ixia/inc
-lEvents_incpath := -I$(services_root)Events/inc
-lSyntheticTest_incpath := -I$(services_root)SyntheticTest/inc
-lIosfFields_incpath := -I$(services_root)IosfFields/inc
-lXMLParsers_incpath := -I$(services_root)XMLParsers/inc
-lCommuneNet_incpath := -I$(services_root)CommuneNet/inc
-lLeCroy_incpath := -I$(services_root)LeCroy/inc
-lExecutionEngine_incpath := -I$(services_root)ExecutionEngine/inc
-lFpgaRegisterAccessApi_incpath := -I$(services_root)FpgaAccess/FpgaAccessApi
-lftd2xx_incpath := -I$(services_root)FpgaAccess/ftdi_driver
-lDukeProxy_incpath := -I$(services_root)FpgaAccess/duke_proxy
-lgenesys_proxy_incpath := -I$(services_root)FpgaAccess/genesys_proxy/inc -I$(services_root)/FpgaAccess/genesys_proxy/ftdi_driver
-lVeloceProxy_incpath := -I$(services_root)FpgaAccess/veloce_proxy
-lfpga_shared_code_incpath := -I$(services_root)FpgaAccess/shared_code

#list number 3
#The list above are includes required for compiling objects that make up the respective service library.

-lPacketGeneratorI: -lRegisterFields -lUtilities
-lScapyPacketGenerator: -lUtilities -lPacketGeneratorI
-lUtilities:
-lgUtilities: -lUtilities
-lDescriptorFields: -lUtilities
-lDescriptorFieldsTcl: -lUtilities -lDescriptorFields
-lgDescriptorFields: -lUtilities -lDescriptorFields -lgUtilities
-lDummyService: -lUtilities
-lJdsu: -lUtilities
-lRegisterFields: -lUtilities
-lRegisterFieldsTcl: -lUtilities -lRegisterFields
-lgRegisterFields: -lUtilities -lRegisterFields
-lOnRingElements: -lDescriptorFields -lUtilities
-lPcktDescDBTcl: -lDescriptorFields -lUtilities -lOnRingElements
-lAdminQueue: -lUtilities
-lAnue: -lUtilities
-lNVMFields: -lUtilities
-lHMCFields: -lUtilities
-lIxia: -lUtilities
-lEvents: -lUtilities
-lSyntheticTest: -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
-lIosfFields: -lUtilities
-lXMLParsers: -lUtilities
-lCommuneNet: -lUtilities
-lLeCroy: -lUtilities
-lExecutionEngine: -lUtilities
-lFpgaRegisterAccessApi: -lDukeProxy -lgenesys_proxy -lVeloceProxy -lftd2xx
-lftd2xx:
-lDukeProxy: -lftd2xx -lfpga_shared_code
-lgenesys_proxy: -lftd2xx -lfpga_shared_code
-lVeloceProxy: -lftd2xx -lfpga_shared_code
-lfpga_shared_code:

#list number 4
#The list above are "target: prerequisites" tuples it defines the dependency relation between each library.
# Example:
# 	to compile the library for "SyntheticTest" make must first compile if needed the libraries for Utilities HMCFields XMLParsers DescriptorFields and OnRingElements
# 	to compile the library "OnRingElements" make must first compile the libraries for "DescriptorFields" and "Utilities" and so on ...
# 	after reading the "target : prerequisites" list make will build a table with the order of invocation for the targets.

-lPacketGeneratorI_rpathlink := -lRegisterFields -lUtilities
-lScapyPacketGenerator_rpathlink := -lUtilities -lPacketGeneratorI
-lUtilities_rpathlink :=
-lgUtilities_rpathlink := -lUtilities
-lDescriptorFields_rpathlink := -lUtilities
-lDescriptorFieldsTcl_rpathlink := -lUtilities -lDescriptorFields
-lgDescriptorFields_rpathlink := -lUtilities -lDescriptorFields -lgUtilities
-lJdsu_rpathlink := -lUtilities
-lRegisterFields_rpathlink := -lUtilities
-lRegisterFieldsTcl_rpathlink := -lUtilities -lRegisterFields
-lgRegisterFields_rpathlink := -lUtilities -lRegisterFields
-lOnRingElements_rpathlink := -lDescriptorFields -lUtilities
-lPcktDescDBcl_rpathlink := -lDescriptorFields -lUtilities -lOnRingElements
-lAdminQueue_rpathlink := -lUtilities
-lAnue_rpathlink := -lUtilities
-lNVMFields_rpathlink := -lUtilities
-lHMCFields_rpathlink := -lUtilities
-lIxia_rpathlink := -lUtilities
-lEvents_rpathlink := -lUtilities
-lSyntheticTest_rpathlink := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
-lIosfFields_rpathlink := -lUtilities
-lXMLParsers_rpathlink := -lUtilities
-lCommuneNet_rpathlink := -lUtilities
-lLeCroy_rpathlink := -lUtilities
-lExecutionEngine_rpathlink := -lUtilities
-lFpgaRegisterAccessApi_rpathlink := -lDukeProxy -lgenesys_proxy -lVeloceProxy -lftd2xx
-lftd2xx_rpathlink :=
-lDukeProxy_rpathlink := -lftd2xx -lfpga_shared_code
-lgenesys_proxy_rpathlink := -lftd2xx -lfpga_shared_code
-lVeloceProxy_rpathlink := -lftd2xx -lfpga_shared_code
-lfpga_shared_code_rpathlink :=

#list number 5
#The list above is ordered similar to the "target: prerequisites" list, for each library requested it returns another lists of libraries for use by the linker flag -Wl,-rpath=
#per example if making the library for VeloceProxy 'LDFLAGS' will contains -Wl,-rpath=$(services_root)FpgaAccess/ftdi_driver:$(services_root)FpgaAccess/shared_code

#in addition it uses the list to recursevly walk through it looking for dependent libraries in cases any is missing or needs to be recompiled in case a dependent library became newer than the one it's dependending on

#the way it looks for the paths with the location of the libraries is with the list mentioned before containg the suffix _searchpath
# Example: -lVeloceProxy_searchpath := $(services_root)FpgaAccess/veloce_proxy

_all_lib_inc :=
all_lib_inc := $(all_lib_inc)
lib_inc := $(lib_inc)
paths :=
CPPFLAGS := $(CPPFLAGS)
LDFLAGS := $(LDFLAGS)
LDLIBS := $(LDLIBS)
rpath-link := -Wl,-rpath=

define recurse_rpathlink
tmp_libs := $$(filter-out $$($(2)_rpath_libs),$$($(1)_rpathlink))
$(2)_rpath_libs += $$(tmp_libs)
$$(foreach lib,$$(tmp_libs),$$(eval $$(call recurse_rpathlink,$$(lib),$(2))))
endef

#this is the code that recurses through 'TARGET_rpath_libs'

define targets_preq_template
$(1)_preq := $(or $($(1)_preq),$($(2)))
endef

#if 'TARGET_preq' is defined it will use the list from the variable else it will use the list from 'targets_so_preq'

define targets_so_template
preq := $$(or $$($(1)_preq),$$($(1)_rpathlink))
$(1)_path := $$(foreach lib,$$(preq),$$($$(lib)_searchpath))
$(1)_rpath_libs := $$(foreach lib,$$(preq),$$($$(lib)_rpathlink))
$$(foreach lib,$$($(1)_rpath_libs),$$(eval $$(call recurse_rpathlink,$$(lib),$(1))))

$(1): $(private) LDFLAGS := $(LDFLAGS) $$($(1)_path:%=-L%) $$(if $$($(1)_path),$$(rpath-link)$$(subst $$(space),:,$$(abspath $$($(1)_path))))
$(1): $(private) LDLIBS := $(LDLIBS) $$(preq)
$(1): $$(preq)
$(1)_lib_inc := $$(foreach lib,$$(preq),$$($$(lib)_incpath)) $$($(1)_incpath)
paths += $$($(1)_path) $$(foreach lib,$$($(1)_rpath_libs),$$($$(lib)_searchpath)) $$($(1)_searchpath)
_all_lib_inc += $$($(1)_lib_inc)
endef

#the block above first reads TARGET_preq ( $(1) is equal to TARGET ) if that is defined it will save it to 'preq' variable else it will use the list from 'TARGET_rpathlink'
#example try -lUtilities_preq and if not defined fallback to reading -lUtilities_rpathlink variable from this preq.mk file
#then for each TARGET in 'preq' variable it will look for 'TARGET_searchpath' variable in this file, which returns the relative pathname where library (TARGET) can be found after compilation this is saved in TARGET_path variable.

#TARGET_path variable is used to set -L flags, -rpath= linker flag and saved to target specific variable 'LDFLAGS' of the target TARGET
Example:
#	-lPacketGeneratorI: private LDFLAGS := $(LDFLAGS) -L../../RegisterFields -L../../Utilities -Wl,-rpath=../../RegisterFields:../../Utilities
#
#any previously globally set value to LDFLAGS is appended to target specific copy of LDFLAGS

#for each library prerequisite in 'preq' variable defined above it will search for a variable 'TARGET_rpathlink' in this preq.mk file, the result is saved to 'TARGET_rpath_libs'
#$$(call recurse_rpathlink ...   uses TARGET_rpath_libs to recurse through each prerequisite looking for its prerequisite until there is none.

#the result is saved back to 'TARGET_rpath_libs' filtering out any duplicates.
#for each LIBRARY in 'TARGET_rpath_libs' its path is searched using 'LIBRARY_searchpath' variables from the list number 2 mentioned in this preq.mk file
#the result is appended to the variable 'paths' make will use this variable to locate our targets and prerequisites in services source tree.

#preq variable is also used for setting target specific variable 'LDLIBS' of the target TARGET
# Example:
# 	-lPacketGeneratorI: private LDLIBS := $(LDLIBS) -lRegisterFields -lUtilities
#
#any previously globally set value to LDLIBS is appended to target specific copy of LDLIBS
#
# 	this can later be used in -lPacketGeneratorI's recipe for linking 
# 	Example: 
# 		-lPacketGeneratorI: $(objects)
# 			$(CXX) -shared -Wl,-soname,libPacketGeneratorI.so -o libPacketGeneratorI.so.0.0 $(objects) $(LDFLAGS) $(LDLIBS)
#
# preq variable is also used for
# 1) specifying TARGET prerequisites like so: $(1): $$(preq), expanding to -lPacketGeneratorI: -lRegisterFields -lUtilities
# 2) retrieving include paths of prerequisite in 'preq' variable and later appending them all to 'all_lib_inc' variable

define targets_template
$(1)_path := $$(foreach lib,$$($(1)_preq),$$($$(lib)_searchpath))
$(1)_rpath_libs := $$(foreach lib,$$($(1)_preq),$$($$(lib)_rpathlink))
$$(foreach lib,$$($(1)_rpath_libs),$$(eval $$(call recurse_rpathlink,$$(lib),$(1))))

$(1): $(private) LDFLAGS := $(LDFLAGS) $$($(1)_path:%=-L%) $$(if $$($(1)_path),$$(rpath-link)$$(subst $$(space),:,$$(abspath $$($(1)_path))))
$(1): $(private) LDLIBS := $(LDLIBS) $$($(1)_preq)
$(1)_lib_inc := $$(foreach lib,$$($(1)_preq),$$($$(lib)_incpath))
$(1): $(private) CPPFLAGS := $(CPPFLAGS) $$($(1)_lib_inc)
$(1): $$($(1)_preq)
paths += $$($(1)_path) $$(foreach lib,$$($(1)_rpath_libs),$$($$(lib)_searchpath))
_all_lib_inc += $$($(1)_lib_inc)
endef

#Same as the block before except in addition to LDFLAGS and LDLIBS target specific variables CPPFLAGS is also set with the include paths gathered from LIBRARY_incpath. 
#for each value in TARGET_preq LIBRARY is name of that value
#any previously globally set value to CPPFLAGS is appended to target specific copy of CPPFLAGS

ifdef targets_so
 ifdef targets_so_preq
   $(foreach t,$(targets_so),$(eval $(call targets_preq_template,$(t),targets_so_preq)))
 endif
$(foreach target_so,$(targets_so),$(eval $(call targets_so_template,$(target_so))))
endif

#the block above scans through libraries "TARGETs" defined in 'targets_so' variable for each one of them it will set the variable 'TARGET_preq' to the list defined in 'targets_so_preq' variable using the template 'targets_preq_template' or in case 'TARGET_preq' was explicitly defined in the Makefile it will use that. afterwards it will call the template targets_so_template with the "TARGETs" defined in 'targets_so' which then will read 'TARGET_preq for each 'TARGET'

ifdef targets
 ifdef targets_preq
   $(foreach t,$(targets),$(eval $(call targets_preq_template,$(t),targets_preq)))
 endif
$(foreach target,$(targets),$(eval $(call targets_template,$(target))))
endif

#Same as block before except instead of 'target_so' it processes the variable 'targets' and 'targets_preq'

all_lib_inc += $(sort $(_all_lib_inc))

ifdef set_inc
lib_inc += $(foreach lib,$(set_inc),$($(lib)_incpath))
lib_inc := $(sort $(lib_inc))
all_lib_inc += $(filter-out $(all_lib_inc),$(lib_inc))
endif

#this is where libraries saved to variable 'set_inc' their include paths are gathered and saved back to the variable 'lib_inc'
#lib_inc is also appended to all_lib_inc

%.o: CPPFLAGS := $(strip $(CPPFLAGS) $(all_lib_inc))

#this is where 'all_lib_inc' value is saved to CPPFLAGS as target specific variable %.o implicit rule.

v_paths := $(sort $(paths))
.LIBPATTERNS := $(foreach path,$(v_paths),$(path)/lib%.so $(path)/lib%.a)

#Make reads this variable to locate any file in the form -lNAME appearing as prerequisite of a target, here it will use paths appended to the variable 'paths' using the name libNAME.so or libNAME.a

vpath %.so $(v_paths)
vpath %.a $(v_paths)

#any target or prerequisite in the Makefile having a .so or .a suffix is also searched using 'paths' 

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
#this avoids implicit rule lookup for re-generating a makefile named 'Makefile' (make will search for a target with the name of the makefile it has loaded/included, run their recipes and if any of the makefiles changed it will restart make again and reread the makefiles)

.DELETE_ON_ERROR:

#this causes make to delete any file target that was created but one of its recipes exited with an error, this is useful for getting rid of partially created object file or any other faulty corrupt target that wasn't succesfully created.

%preq.mk: ;
#this avoids implicit rule lookup for re-generating this preq.mk file.

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
	$$(CXX) $$(all_lib_inc) -MT '$$(patsubst %$$(suffix $$<),%.o,$$<)' -MT '$$@' -MM $$< > $$@

#Include ".d" makefiles file if goals are not only clean and/or clean_lib
ifneq ($$(MAKECMDGOALS),)
ifneq ($$(filter-out clean clean_% clean-% install install_% install-%,$$(MAKECMDGOALS)),)
-include $$(includes)
endif
else
-include $$(includes)
endif
endef

ifeq ($(.DEFAULT_GOAL),dummygoal)
  .DEFAULT_GOAL :=
endif
