#this makefile is used for resolving library Prerequisites and compiling them before the final target_so or target

#variables used are:
# targets_so := \
	name of shared libraries to create, example: libUtilities.so libEvents.so ...
# $(target_so)_preq := \
	set a lists of library Prerequisites used by a target_so outside of target_so source tree, example: -lUtilities -lEvents RCF.o ...

#targets := \
	name of executables to create, example: testprogram tesrprogram1 ...

# $(target)_preq := \
	set a lists of library Prerequisites used by a target outside of target's source tree, example: -lUtilities -lEvents RCF.o ...

# targets_preq := \
	set a list of library Prerequisites shared and used by all targets listed in $(targets)

# targets_so_preq := \
	set a list of library Prerequisites shared and used by all targets listed in $(targets_so)

# set_inc := \
# lib_inc := \
	set_inc lists libraries Prerequisites example: -lUtilities -lEvents RCF.o ... \
	$(lib_inc) will have -I flags resolved from $(set_inc)

#
#linker -L flags are resolved for prerequistes listed in $($(target)_preq) and $($(target_so)_preq) and the result is saved in a private LDFLAGS variable for that target
#linker flag -rpath-link are resolved for libraries listed in $($(target)_preq), these are also saved in LDFLAGS variable
#linker -l flags listed in $($(target_so)_preq) are saved as private variable LDLIBS for the target and set as prerequistes for corresponding target listed in $(targets), in a similar manner done for $($(target_so)_preq) for $(targets_so)
#include -I flags are resolved from $($(target)_preq) and saved as private variable CPPFLAGS

#In addition include directories for all libraries Prerequisites set to targets_so_preq/targets_preq $(target)_preq/$(target_so)_preq are auto resolved and added to "all_lib_inc" variable

#shortest-stem was introduced in gnu make 3.82 which also introduced target-specific private variables
ifneq ($(filter shortest-stem,$(.FEATURES)),)
private := private
endif

nullstring :=
space := $(nullstring) #
curdir := $(subst $(space),```,$(CURDIR))

ifeq ($(filter %sv_driver,$(curdir)),)
delimited := $(subst /sv_driver/,$(space),$(curdir))
delimited_minus_lastword := $(filter-out $(lastword $(delimited)),$(delimited))$(space)
sv_driver_root := $(subst ```,$(space),$(subst $(space),/sv_driver,$(delimited_minus_lastword)))
else
sv_driver_root := $(CURDIR)
endif
services_root := $(abspath $(sv_driver_root)/../services)

define -lPacketGeneratorI 
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lScapyPacketGenerator
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lUtilities
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src $(@:-l%=lib%.so)
endef
define -lgUtilities
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lDescriptorFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src ../$(@:-l%=lib%.so)
endef
define -lgDescriptorFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lDummyService
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lJdsu
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lRegisterFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src ../$(@:-l%=lib%.so)
endef
define -lgRegisterFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src ../$(@:-l%=lib%.so)
endef
define -lOnRingElements
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src ../$(@:-l%=lib%.so)
endef
define -lAdminQueue
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lAnue
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lNVMFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lHMCFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src ../$(@:-l%=lib%.so)
endef
define -lIxia
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lEvents
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lSyntheticTest
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lIosfFields
	+$(MAKE) -C $(services_root)/$(@:-l%=%)/src ../$(@:-l%=lib%.so)
endef
define -lXMLParsers
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lCommuneNet
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lLeCroy
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lExecutionEngine
	+$(MAKE) -C $(services_root)/$(@:-l%=%) $(@:-l%=lib%.so)
endef
define -lFpgaRegisterAccessApi
	+$(MAKE) -C $(services_root)/FpgaAccess/FpgaAccessApi $(@:-l%=lib%.so)
endef
define -lftd2xx
	+$(MAKE) -C $(services_root)/FpgaAccess/ftdi_driver $(@:-l%=lib%.so)
endef
define -lDukeProxy
	+$(MAKE) -C $(services_root)/FpgaAccess/duke_proxy $(@:-l%=lib%.so)
endef
define -lgenesys_proxy
	+$(MAKE) -C $(services_root)/FpgaAccess/genesys_proxy/src $(@:-l%=lib%.so)
endef
define -lVeloceProxy
	+$(MAKE) -C $(services_root)/FpgaAccess/veloce_proxy $(@:-l%=lib%.so)
endef
define -lpktgen
	+$(MAKE) -C $(sv_driver_root)/pktgen bin/$(@:-l%=lib%.a)
endef
define RCF.o
	+$(MAKE) -C $(sv_driver_root)/remoting RCF
endef
define -lDriverIwarpApi
	+$(MAKE) -C $(sv_driver_root)/api/iwarp/src ../lib/$(@:-l%=lib%.so)
endef
define -lDriverApi
	+$(MAKE) -C $(sv_driver_root)/api/src $(@:-l%=lib%.so)
endef
define -lPciApi
	+$(MAKE) -C $(sv_driver_root)/pci/api/src $(@:-l%=lib%.so)
endef
define -lJtagAccess
	+$(MAKE) -C $(sv_driver_root)/jtagAccess/src $(@:-l%=lib%.so)
endef
define -lftcjtag
	+$(MAKE) -C $(sv_driver_root)/jtagAccess/ftcjtag $(@:-l%=lib%.so)
endef
define -lHmcDebug
	+$(MAKE) -C $(sv_driver_root)/tools/hmc_debug/hmc_debug_lib/src $(@:-l%=lib%.so)
endef

.PHONY: dummygoal
dummygoal: ;

RCF.o:
	$(call $@)
-l%:
	$(call $@)

-lPacketGeneratorI_searchpath := $(services_root)/PacketGeneratorI
-lRegisterFields_searchpath := $(services_root)/RegisterFields
-lgRegisterFields_searchpath := $(services_root)/gRegisterFields
-lUtilities_searchpath := $(services_root)/Utilities
-lgUtilities_searchpath := $(services_root)/gUtilities
-lScapyPacketGenerator_searchpath := $(services_root)/ScapyPacketGenerator
-lDescriptorFields_searchpath := $(services_root)/DescriptorFields
-lgDescriptorFields_searchpath := $(services_root)/gDescriptorFields
-lDummyService_searchpath := $(services_root)/DummyService
-lJdsu_searchpath := $(services_root)/Jdsu
-lOnRingElements_searchpath := $(services_root)/OnRingElements
-lAdminQueue_searchpath := $(services_root)/AdminQueue
-lAnue_searchpath := $(services_root)/Anue
-lNVMFields_searchpath := $(services_root)/NVMFields
-lHMCFields_searchpath := $(services_root)/HMCFields
-lIxia_searchpath := $(services_root)/Ixia
-lEvents_searchpath := $(services_root)/Events
-lSyntheticTest_searchpath := $(services_root)/SyntheticTest
-lIosfFields_searchpath := $(services_root)/IosfFields
-lXMLParsers_searchpath := $(services_root)/XMLParsers
-lCommuneNet_searchpath := $(services_root)/CommuneNet
-lLeCroy_searchpath := $(services_root)/LeCroy
-lExecutionEngine_searchpath := $(services_root)/ExecutionEngine
-lFpgaRegisterAccessApi_searchpath := $(services_root)/FpgaAccess/FpgaAccessApi
-lftd2xx_searchpath := $(services_root)/FpgaAccess/ftdi_driver
-lDukeProxy_searchpath := $(services_root)/FpgaAccess/duke_proxy
-lgenesys_proxy_searchpath := $(services_root)/FpgaAccess/genesys_proxy/src
-lVeloceProxy_searchpath := $(services_root)/FpgaAccess/veloce_proxy
-lpktgen_searchpath := $(sv_driver_root)/pktgen/bin
RCF.o_searchpath := $(sv_driver_root)/remoting/Rcf
-lDriverIwarpApi_searchpath := $(sv_driver_root)/api/iwarp/lib
-lDriverApi_searchpath := $(sv_driver_root)/api/lib
-lPciApi_searchpath := $(sv_driver_root)/pci/api/src
-lJtagAccess_searchpath := $(sv_driver_root)/jtagAccess/src
-lftcjtag_searchpath := $(sv_driver_root)/jtagAccess/ftcjtag
-lHmcDebug_searchpath := $(sv_driver_root)/tools/hmc_debug/hmc_debug_lib/lib

-lPacketGeneratorI_incpath := $(patsubst %,-I$(services_root)/PacketGeneratorI/%,IPackets/inc Utilities/inc Payload/inc ILayers/inc IFactory/inc)
-lRegisterFields_incpath := -I$(services_root)/RegisterFields/inc
-lgRegisterFields_incpath := -I$(services_root)/gRegisterFields/inc
-lUtilities_incpath := -I$(services_root)/Utilities/inc
-lgUtilities_incpath := -I$(services_root)/gUtilities/inc
-lScapyPacketGenerator_incpath := $(patsubst %,-I$(services_root)/ScapyPacketGenerator/%,PythonServices/inc ScapyFactory/inc ScapyLayers/inc ScapyPackets/inc)
-lDescriptorFields_incpath := -I$(services_root)/DescriptorFields/inc
-lgDescriptorFields_incpath := -I$(services_root)/gDescriptorFields/inc
-lDummyService_incpath := -I$(services_root)/DummyService/inc
-lJdsu_incpath := -I$(services_root)/Jdsu/inc
-lOnRingElements_incpath := -I$(services_root)/OnRingElements/inc
-lAdminQueue_incpath := -I$(services_root)/AdminQueue/inc
-lAnue_incpath := -I$(services_root)/Anue/inc
-lNVMFields_incpath := -I$(services_root)/NVMFields/inc
-lHMCFields_incpath := -I$(services_root)/HMCFields/inc
-lIxia_incpath := -I$(services_root)/Ixia/inc
-lEvents_incpath := -I$(services_root)/Events/inc
-lSyntheticTest_incpath := -I$(services_root)/SyntheticTest/inc
-lIosfFields_incpath := -I$(services_root)/IosfFields/inc
-lXMLParsers_incpath := -I$(services_root)/XMLParsers/inc
-lCommuneNet_incpath := -I$(services_root)/CommuneNet/inc
-lLeCroy_incpath := -I$(services_root)/LeCroy/inc
-lExecutionEngine_incpath := -I$(services_root)/ExecutionEngine/inc
-lFpgaRegisterAccessApi_incpath := -I$(services_root)/FpgaAccess/FpgaAccessApi
-lftd2xx_incpath := -I$(services_root)/FpgaAccess/ftdi_driver
-lDukeProxy_incpath := -I$(services_root)/FpgaAccess/duke_proxy
-lgenesys_proxy_incpath := -I$(services_root)/FpgaAccess/genesys_proxy/inc -I$(services_root)/FpgaAccess/genesys_proxy/ftdi_driver
-lVeloceProxy_incpath := -I$(services_root)/FpgaAccess/veloce_proxy
-lpktgen_incpath := -I$(sv_driver_root)/pktgen/pktgen_lib/inc
RCF.o_incpath := -I$(sv_driver_root)/remoting/Rcf/include/RCF/test -I$(sv_driver_root)/remoting/server
-lDriverIwarpApi_incpath := -I$(sv_driver_root)/api/iwarp/inc
-lDriverApi_incpath := -I$(sv_driver_root)/api/inc
-lPciApi_incpath := -I$(sv_driver_root)/pci/api/inc
-lJtagAccess_incpath := -I$(sv_driver_root)/jtagAccess/inc
-lftcjtag_incpath := -I$(sv_driver_root)/jtagAccess/ftcjtag/inc
-lHmcDebug_incpath := -I$(sv_driver_root)/tools/hmc_debug/hmc_debug_lib/hmc_debug_lib/pe_fw_hmc_structs -I$(sv_driver_root)/tools/hmc_debug/hmc_debug_lib/hmc_debug_lib/inc

-lPacketGeneratorI: -lRegisterFields -lUtilities
-lScapyPacketGenerator: -lUtilities -lPacketGeneratorI
-lUtilities:
-lgUtilities: -lUtilities
-lDescriptorFields: -lUtilities
-lgDescriptorFields: -lUtilities -lDescriptorFields -lgUtilities
-lDummyService: -lUtilities
-lJdsu: -lUtilities
-lRegisterFields: -lUtilities
-lgRegisterFields: -lUtilities -lRegisterFields
-lOnRingElements: -lDescriptorFields -lUtilities
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
-lDukeProxy: -lftd2xx
-lgenesys_proxy: -lftd2xx
-lVeloceProxy: -lftd2xx
-lpktgen:
RCF.o:
-lDriverIwarpApi: RCF.o
-lDriverApi: -lpktgen
-lPciApi:
-lJtagAccess: -lftcjtag
-lftcjtag: -lftd2xx
-lHmcDebug:

-lPacketGeneratorI_rpathlink := -lRegisterFields -lUtilities
-lScapyPacketGenerator_rpathlink := -lUtilities -lPacketGeneratorI
-lUtilities_rpathlink :=
-lgUtilities_rpathlink := -lUtilities
-lDescriptorFields_rpathlink := -lUtilities
-lgDescriptorFields_rpathlink := -lUtilities -lDescriptorFields -lgUtilities
-lJdsu_rpathlink := -lUtilities
-lRegisterFields_rpathlink := -lUtilities
-lgRegisterFields_rpathlink := -lUtilities -lRegisterFields
-lOnRingElements_rpathlink := -lDescriptorFields -lUtilities
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
-lDukeProxy_rpathlink := -lftd2xx
-lgenesys_proxy_rpathlink := -lftd2xx
-lVeloceProxy_rpathlink := -lftd2xx
-lpktgen_rpathlink :=
RCF.o_rpathlink := 
-lDriverIwarpApi_rpathlink := RCF.o
-lDriverApi_rpathlink := -lpktgen
-lPciApi_rpathlink := 
-lJtagAccess_rpathlink := -lftcjtag
-lftcjtag_rpathlink := -lftd2xx
-lHmcDebug_rpathlink :=

_all_lib_inc :=
ifndef all_lib_inc
all_lib_inc :=
endif
ifndef lib_inc
lib_inc :=
endif
paths :=
rpath_libs :=
rpath_link :=
ifndef CPPFLAGS
CPPFLAGS :=
endif
ifndef LDFLAGS
LDFLAGS :=
endif
ifndef LDLIBS
LDLIBS :=
endif

define targets_preq_template
$(1)_preq := $($(2))
endef

define targets_so_template
$(1)_path := $$(foreach lib,$$($(1)_preq),$$($$(lib)_searchpath))
$(1): $(private) LDFLAGS := $(LDFLAGS) $$($(1)_path:%=-L%)
$(1): $(private) LDLIBS := $(LDLIBS) $$($(1)_preq)
$(1): $$($(1)_preq)
$(1)_lib_inc := $$(foreach lib,$$($(1)_preq),$$($$(lib)_incpath))
paths += $$($(1)_path)
_all_lib_inc += $$($(1)_lib_inc)
endef

define targets_template
$(1)_path := $$(foreach lib,$$($(1)_preq),$$($$(lib)_searchpath))
$(1)_rpath_libs := $$(foreach lib,$$($(1)_preq),$$($$(lib)_rpathlink))
$(1)_rpath_link := $$(sort $$(foreach lib,$$($(1)_rpath_libs),$$($$(lib)_searchpath)))
$(1): $(private) LDFLAGS := $(LDFLAGS) $$($(1)_path:%=-L%) -Wl,-rpath-link=$$(subst $$(space),:,$$($(1)_rpath_link))
$(1): $(private) LDLIBS := $(LDLIBS) $$($(1)_preq)
$(1)_lib_inc := $$(foreach lib,$$($(1)_preq),$$($$(lib)_incpath))
$(1): $(private) CPPFLAGS := $(CPPFLAGS) $$($(1)_lib_inc)
$(1): $$($(1)_preq)
paths += $$($(1)_path)
rpath_link += $$($(1)_rpath_link)
_all_lib_inc += $$($(1)_lib_inc)
endef

ifdef targets_so
 ifdef targets_so_preq
   $(foreach t,$(targets_so),$(eval $(call targets_preq_template,$(t),targets_so_preq)))
 endif
$(foreach target_so,$(targets_so),$(eval $(call targets_so_template,$(target_so))))
endif

ifdef targets
 ifdef targets_preq
   $(foreach t,$(targets),$(eval $(call targets_preq_template,$(t),targets_preq)))
 endif
$(foreach target,$(targets),$(eval $(call targets_template,$(target))))
endif

all_lib_inc += $(sort $(_all_lib_inc))

ifdef set_inc
lib_inc += $(foreach lib,$(set_inc),$($(lib)_incpath))
lib_inc := $(sort $(lib_inc))
all_lib_inc += $(filter-out $(all_lib_inc),$(lib_inc))
endif

v_paths := $(sort $(paths) $(rpath_link))
vpath %.so $(v_paths)
vpath %.a $(v_paths)
vpath RCF.o $(v_paths)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
.DELETE_ON_ERROR:

%preq.mk: ;

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
ifneq ($$(filter-out clean clean_lib install,$$(MAKECMDGOALS)),)
-include $$(includes)
endif
else
-include $$(includes)
endif
endef

ifeq ($(.DEFAULT_GOAL),dummygoal)
  .DEFAULT_GOAL :=
endif
