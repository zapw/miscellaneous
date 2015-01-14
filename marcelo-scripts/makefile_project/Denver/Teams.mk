############				Global Defs 		###########################
DENVER_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))

CORE_ROOT := $(DENVER_ROOT)core
TEAM_ROOT := $(DENVER_ROOT)teams/$(TEAM_NAME)
ADAPTERS_ROOT := $(DENVER_ROOT)adapters/
EXE_NAME := Denver

########################################	Adapters 	##########################
###in order to use this , the makefile should have the label ADAPTERS := IPs/Eth/10Gs IPs/Eth/40G_iwarp ....##########

ifdef ADAPTERS
ALL_ADAPTERS := $(wildcard $(addprefix $(ADAPTERS_ROOT),$(ADAPTERS:%=%/)))

GENERIC_ADAPTERS_INC := $(addprefix -I,$(foreach adapter,$(ALL_ADAPTERS),$(wildcard $(adapter)AdapterClasses/Generic/inc/ $(adapter)AdapterClasses/inc/)))
FAMILY_ADAPTERS_INC := $(addprefix -I,$(foreach adapter,$(ALL_ADAPTERS),$(wildcard $(adapter)AdapterClasses/family/inc/)))
PATH_TO_PRODUCT_ADAPTERS := $(patsubst %,%AdapterClasses/products,$(filter-out %/Generic/, $(ALL_ADAPTERS)))
PATH_TO_PRODUCT_ADAPTERS := $(filter-out %Generic/ %CVS/,$(filter %/, $(wildcard $(addsuffix /*/,$(PATH_TO_PRODUCT_ADAPTERS)))))

PRODUCT_ADAPTERS_INC := $(patsubst %,-I%inc,$(PATH_TO_PRODUCT_ADAPTERS))

GLOBAL_INFRA_ADAPTERS_INC := $(addprefix -I,$(foreach adapter,$(ALL_ADAPTERS),$(wildcard $(adapter)infrastructure/inc/ $(adapter)infrastructure/Generic/inc/)))
PRODUCT_INFRA_ADAPTERS_INC := $(addprefix -I,$(foreach adapter,$(ALL_ADAPTERS),$(wildcard $(adapter)infrastructure/products/inc/)))
endif 

GENERIC_ADAPTERS := -I$(DENVER_ROOT)adapters/IPs/Eth/Generic/semi_generic/inc -I$(DENVER_ROOT)adapters/IPs/Eth/Generic/PCIe/inc -I$(DENVER_ROOT)adapters/IPs/Eth/Generic/AdapterClasses/inc -I$(DENVER_ROOT)adapters/IPs/Eth/Generic/infrastructure/inc -I$(DENVER_ROOT)adapters/IPs/Switch/Generic/AdapterClasses/inc
##########################################################################################


#######################################		Team infra 	##########################

TEAM_INFRA := $(TEAM_ROOT)/infrastructure
TEAM_FAMILY_INFRA_INC := $(TEAM_FAMILY_INFRA_INC) -I$(TEAM_INFRA)/family/inc -I$(TEAM_INFRA)/family/
TEAM_PRODUCT_INFRA_INC := $(TEAM_PRODUCT_INFRA_INC) -I$(TEAM_INFRA)/products/inc -I$(TEAM_INFRA)/products/
TEAM_GENERIC_INFRA_INC := $(TEAM_GENERIC_INFRA_INC) -I$(TEAM_INFRA)/generic/inc -I$(TEAM_INFRA)/generic/

#######################################		services	##########################
GLOBAL_SERVICES := Utilities RegisterFields DescriptorFields PacketGeneratorI OnRingElements AdminQueue XMLParsers Events Ixia Jdsu LeCroy Anue CommuneNet  NVMFields HMCFields SyntheticTest IosfFields DummyService ExecutionEngine

#Just Checking Install Denver bug - Teams.mk

SCAPY_INC := -I/usr/include/services/ScapyPacketGenerator

GLOBAL_SERVICES_INC := $(foreach service,$(GLOBAL_SERVICES), $(addprefix -I/usr/include/services/,$(service) ) )
GLOBAL_SERVICES_INC += -I/usr/include/fpga_access/
#######################################		driver		###########################
DRIVER_INC= -I/usr/include/sv_driver/api/ -I/usr/include/sv_driver/api/iwarp/ -I/usr/include/sv_driver/pci/
###########################################################################################


#######################################		other libs	###########################
OTHER_LIBS_INC = -I/usr/share/pvm3/include/
###########################################################################################


#######################################		core		###########################
CORE_INFRA_INC= -I$(CORE_ROOT)/infrastructure/inc -I$(CORE_ROOT)/infrastructure/adapters/inc -I$(CORE_ROOT)/infrastructure/SyntheticTest/inc
CORE_EXEC_INC= -I$(CORE_ROOT)/executionEngine/inc
ifdef SVOS
CORE_ROCKET_EXEC_INC = -I$(CORE_ROOT)/executionEngine/rocket/inc
endif
###########################################################################################

###########################################################################################
######################		FINAL INCS FOR TEAM  		###########################
GLOBAL_INC_PRE := -I../inc $(GLOBAL_SERVICES_INC) $(DRIVER_INC) $(CORE_INFRA_INC) $(GENERIC_ADAPTERS) $(TEAM_GENERIC_INFRA_INC)
GLOBAL_INC_POST := $(EXTRA_TEAM_INC) $(OTHER_LIBS_INC) 

FINAL_INFRA_GENERIC_INC = $(GLOBAL_INC_PRE) $(GLOBAL_INFRA_ADAPTERS_INC) $(GENERIC_ADAPTERS_INC) $(SCAPY_INC) $(GLOBAL_INC_POST)
FINAL_INFRA_FAMILY_INC =  $(GLOBAL_INC_PRE) $(TEAM_FAMILY_INFRA_INC) $(GLOBAL_INFRA_ADAPTERS_INC) $(GENERIC_ADAPTERS_INC) $(FAMILY_ADAPTERS_INC) $(GLOBAL_INC_POST) 
FINAL_INFRA_PRODUCT_INC = $(GLOBAL_INC_PRE) $(TEAM_FAMILY_INFRA_INC) $(TEAM_PRODUCT_INFRA_INC) $(GLOBAL_INFRA_ADAPTERS_INC) $(PRODUCT_INFRA_ADAPTERS_INC) $(GENERIC_ADAPTERS_INC) $(FAMILY_ADAPTERS_INC) $(PRODUCT_ADAPTERS_INC) $(GLOBAL_INC_POST)

FINAL_TESTS_GENERIC_INC = $(GLOBAL_INC_PRE) $(GLOBAL_INFRA_ADAPTERS_INC) $(GENERIC_ADAPTERS_INC) $(GLOBAL_INC_POST)
FINAL_TESTS_FAMILY_INC =  $(GLOBAL_INC_PRE) $(TEAM_FAMILY_INFRA_INC) $(GLOBAL_INFRA_ADAPTERS_INC) $(GENERIC_ADAPTERS_INC) $(FAMILY_ADAPTERS_INC) $(GLOBAL_INC_POST)
FINAL_TESTS_PRODUCT_INC = $(GLOBAL_INC_PRE) $(TEAM_FAMILY_INFRA_INC) $(TEAM_PRODUCT_INFRA_INC) $(GLOBAL_INFRA_ADAPTERS_INC) $(PRODUCT_INFRA_ADAPTERS_INC) $(GENERIC_ADAPTERS_INC) $(FAMILY_ADAPTERS_INC) $(PRODUCT_ADAPTERS_INC) $(GLOBAL_INC_POST)

FINAL_SAMPLES_INC = $(FINAL_TESTS_PRODUCT_INC)

###########################################################################################

#######################	compilation flags	###########################################
DBG := -g
CXXFLAGS := $(CXXFLAGS)
CXXFLAGS += -fPIC -Wall -Wno-narrowing
%.o: CPPFLAGS += $(all_lib_inc)
###########################################################################################


######################	bin & linking 		###########################################
################## ADAPTERS LABEL SHOULD BE USED ############################################
GLOBAL_SERVICES_LIBS = $(foreach service,$(GLOBAL_SERVICES), $(addprefix -l,$(service) ) )
SERVICES_LIBS := -lScapyPacketGenerator $(GLOBAL_SERVICES_LIBS)
OTHER_LIBS := -lDriverApi -lDriverIwarpApi -lPciApi -lpcap -lc -lpci -lz -lboost_system -lboost_thread -ldl -lFpgaRegisterAccessApi -lxerces-c  -L /usr/share/pvm3/lib/LINUXX86_64/ -lgpvm3 -lpvm3 -lboost_regex

#ADAPTER_LIBS = $(foreach adapter,$(ADAPTERS_LIBS_NAMES), $(addprefix -l,$(adapter) ) )
#STATIC_LIBS = $(ADAPTERS_PATH) -Wl,--whole-archive -Wl,-Bstatic $(ADAPTER_LIBS) -Wl,--no-whole-archive -Wl,-Bdynamic
#FINAL_LIBS = -Wl,--start-group -L$(CORE_ROOT) $(DYNAMIC_LIBS) $(EXTRA_TEAM_LIB)  -Wl,-rpath,'$$ORIGIN'/$(CORE_ROOT)  -Wl,--end-group

DYNAMIC_LIBS := $(SERVICES_LIBS) -lDenverCore $(OTHER_LIBS)
FINAL_LIBS := -L$(CORE_ROOT) $(DYNAMIC_LIBS) $(EXTRA_TEAM_LIB) -Wl,-rpath,'$$ORIGIN'/$(CORE_ROOT)

FINAL_BIN_INC := $(CORE_INFRA_INC) $(CORE_EXEC_INC) $(GLOBAL_SERVICES_INC) $(DRIVER_INC) $(OTHER_LIBS_INC)
ifdef SVOS
FINAL_BIN_INC += $(CORE_ROCKET_EXEC_INC)
endif

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

.PHONY: dummygoal
dummygoal: ;

ifdef SVOS
 10Gs_team := 10gs
 1Gs_team := 1gs
 DLC_team := fpk
 Crypto_team := fpk
 SVShared_team := svshared
 CPM_team := cpm
 FwKiev_team := fpk
 EthSwitch_team := 10gs
 FRC_team := 10gs
endif

-lGeneric: -lDenverCore
-l40Gs: -lDenverCore
-l10Gs_LAD10Gig: -lDenverCore
-lMstDesignFCsFamily: -lDenverCore
-lGenericFCsFamily: -lDenverCore
-lBMC: -lDenverCore
-lRdma: -lDenverCore
-l1Gs_LAD1Gig: -lDenverCore
-lCPM: -lDenverCore
-lHLPsFamily: -lDenverCore
-lGenericSwitch: -lDenverCore

define -lDenverCore
        +$(MAKE) -C $(CORE_ROOT) -- $(@)
endef

define -lGeneric
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/Generic/ -- $(@)
endef

define -l40Gs
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/40Gs/ -- $(@)
endef

define -l10Gs_LAD10Gig
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/10Gs/ -- $(@)
endef

define -lBMC
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/BMC/ -- $(@)
endef

define -l1Gs_LAD1Gig
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/1Gs/ -- $(@)
endef

define -lCPM
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/CPM/ -- $(@)
endef

define -lRdma
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Eth/Rdma/ -- $(@)
endef

define -lMstDesignFCsFamily
	+$(MAKE) -C $(ADAPTERS_ROOT)FCs/MstDesign/ -- $(@)
endef

define -lGenericFCsFamily
	+$(MAKE) -C $(ADAPTERS_ROOT)FCs/Generic/ -- $(@)
endef

define -lHLPsFamily
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Switch/HLPs/ -- $(@)
endef

define -lGenericSwitch
        +$(MAKE) -C $(ADAPTERS_ROOT)IPs/Switch/Generic/ -- $(@)
endef

ifeq ($(.DEFAULT_GOAL),$(EXE_NAME))
 nullstring :=
 space := $(nullstring) #

 IPs/Switch/Generic := -lGenericSwitch
 IPs/Switch/HLPs := -lHLPsFamily
 IPs/Eth/CPM := -lCPM
 IPs/Eth/1Gs := -l1Gs_LAD1Gig
 IPs/Eth/Rdma := -lRdma
 IPs/Eth/BMC := -lBMC
 IPs/Eth/10Gs := -l10Gs_LAD10Gig
 IPs/Eth/40Gs := -l40Gs
 IPs/Eth/Generic := -lGeneric
 FCs/Generic := -lGenericFCsFamily
 FCs/MstDesign := -lMstDesignFCsFamily
 $(CORE_ROOT) := -lDenverCore

 adapter_libs := $(foreach adapter,$(ADAPTERS),$(call $(patsubst %/,%,$(adapter))))
 $(EXE_NAME): $(adapter_libs)
 $(EXE_NAME): LDLIBS := $(LDLIBS) $(adapter_libs) -lrt
 $(EXE_NAME): LDFLAGS := $(LDFLAGS) $(ALL_ADAPTERS:%=-L%) -Wl,-rpath,$(subst $(space),:,$(addprefix '$$ORIGIN'/,$(ALL_ADAPTERS)))
endif

vpath %.so $(CORE_ROOT) $(ALL_ADAPTERS)
.LIBPATTERNS := $(foreach path,$(CORE_ROOT) $(ALL_ADAPTERS),$(path)/lib%.so $(path)/lib%.a)

-l%:
	$(call $@)

.DELETE_ON_ERROR:

%Teams.mk: ;
%Makefile: ;

include $(DENVER_ROOT)dotd.mk

ifeq ($(.DEFAULT_GOAL),dummygoal)
  .DEFAULT_GOAL :=
endif
