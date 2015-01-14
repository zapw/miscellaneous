############				Global Defs 		###########################
############################ $(ADAPTER_NAME) should be present ############################

DENVER_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))

ADAPTERS_ROOT := $(DENVER_ROOT)adapters
CURR_ADAPTER_ROOT := $(ADAPTERS_ROOT)/$(ADAPTER_NAME)
CORE_ROOT := $(DENVER_ROOT)core
CURR_FAMILY_PRODUCTS_ROOT := $(CURR_ADAPTER_ROOT)/AdapterClasses/products/
CURR_PRODUCTS_BROTHERS_INC := $(patsubst %,-I%,$(wildcard $(CURR_FAMILY_PRODUCTS_ROOT)*/inc/))
CHOSEN_ADAPTERS := $(ADAPTERS)
############################ ADAPTER AdapterClass #######################################

GENERIC_ADAPTERS = -I$(ADAPTERS_ROOT)/IPs/Eth/Generic/AdapterClasses/inc -I$(ADAPTERS_ROOT)/IPs/Eth/Generic/infrastructure/inc -I$(ADAPTERS_ROOT)/IPs/Eth/Generic/semi_generic/inc -I$(ADAPTERS_ROOT)/IPs/Eth/Generic/PCIe/inc  -I$(ADAPTERS_ROOT)/IPs/Switch/Generic/AdapterClasses/inc/

GLOBAL_ADAPTER_INFRA_INC = -I$(CURR_ADAPTER_ROOT)/infrastructure/inc
GENERIC_ADAPTER_INFRA_INC = -I$(CURR_ADAPTER_ROOT)/infrastructure/Generic/inc
FAMILY_ADAPTER_INFRA_INC = -I$(CURR_ADAPTER_ROOT)/infrastructure/family/inc
PRODUCT_ADAPTER_INFRA_INC = -I$(CURR_ADAPTER_ROOT)/infrastructure/products/inc
GENERIC_ADAPTER_INC = -I$(CURR_ADAPTER_ROOT)/AdapterClasses/Generic/inc
FAMILY_ADAPTER_INC = -I$(CURR_ADAPTER_ROOT)/AdapterClasses/family/inc
BMC_ADAPTER_INFRA_INC = -I$(CURR_ADAPTER_ROOT)/infrastructure/Generic/HpDci

#######################################	services & others##########################
GLOBAL_SERVICES := Utilities RegisterFields DescriptorFields PacketGeneratorI OnRingElements AdminQueue Events Ixia  NVMFields HMCFields SyntheticTest XMLParsers IosfFields DummyService ExecutionEngine

PVM_INC = -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
#Just Checking Install Denver bug - Adapters.mk

SCAPY_INC = -I/usr/include/services/ScapyPacketGenerator

GLOBAL_SERVICES_INC = $(patsubst %,-I/usr/include/services/%,$(GLOBAL_SERVICES)) -I/usr/include/fpga_access/
DRIVER_INC = -I/usr/include/sv_driver/api/ -I/usr/include/sv_driver/api/iwarp/ -I/usr/include/sv_driver/pci/   

CORE_INFRA_INC = -I$(CORE_ROOT)/infrastructure/inc -I$(CORE_ROOT)/infrastructure/adapters/inc -I$(CORE_ROOT)/infrastructure/SyntheticTest/inc
CORE_EXEC_INC = -I$(CORE_ROOT)/executionEngine/inc

##########################################################################################
FINAL_INFRA_INC = -I../inc $(DRIVER_INC) $(GLOBAL_SERVICES_INC) $(CORE_INFRA_INC) $(GENERIC_ADAPTERS) $(PVM_INC) $(BMC_ADAPTER_INFRA_INC)
FINAL_FAMILY_INFRA_INC = $(FINAL_INFRA_INC) $(GLOBAL_ADAPTER_INFRA_INC) $(GENERIC_ADAPTER_INFRA_INC) $(BMC_ADAPTER_INFRA_INC) 
FINAL_PRODUCTS_INFRA_INC = $(FINAL_FAMILY_INFRA_INC) $(FAMILY_ADAPTER_INFRA_INC)

FINAL_GENERIC_INC = $(FINAL_FAMILY_INFRA_INC)
FINAL_FAMILY_INC = $(FINAL_PRODUCTS_INFRA_INC) $(GENERIC_ADAPTER_INC)

FINAL_PRODUCT_INC = $(FINAL_FAMILY_INC) $(PRODUCT_ADAPTER_INFRA_INC) $(FAMILY_ADAPTER_INC) $(CURR_PRODUCTS_BROTHERS_INC)

#######################	compilation flags	###########################################
DBG := -g
CXXFLAGS := $(CXXFLAGS)
CXXFLAGS += -fPIC -Wall -Wno-narrowing
%.o: CPPFLAGS += $(all_lib_inc)

#####################Linking stuff############################################

GLOBAL_SERVICES_LIBS = $(patsubst %,-l%,$(GLOBAL_SERVICES))
SERVICES_LIBS = -lScapyPacketGenerator $(GLOBAL_SERVICES_LIBS)
CORE_LIBS = -lDenverCore 
CORE_LINKING_PATH = -L$(CORE_ROOT)
CORE_RUNTIMEPATH = -Wl,-rpath,'$$ORIGIN'/$(CORE_ROOT)
OTHER_LIBS = -lDriverApi -lDriverIwarpApi -lPciApi -lpcap -lc -lpci -lz -lboost_system -lboost_thread -ldl -lFpgaRegisterAccessApi -lxerces-c -lrt -lboost_regex 
LOCAL_LIBS = $(CORE_LINKING_PATH) $(CORE_RUNTIMEPATH)
PVM_LIB= -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3

FINAL_LIBS = $(LOCAL_LIBS) $(SERVICES_LIBS) $(CORE_LIBS) $(OTHER_LIBS) 

######FCs variables #######################################
FC_GENERIC_ADAPTERS = -I$(ADAPTERS_ROOT)/FCs/Generic/AdapterClasses/inc -I$(ADAPTERS_ROOT)/FCs/Generic/infrastructure/inc 

FC_DEP_IPS_ADAPTERS := IPs/Eth/Generic/ IPs/Eth/40Gs/ 
FC_DEP_IPS_ADAPTES_NAME_FOR_LINKING := -lGeneric -l40Gs
FC_DEP_ALL_IPS_FULL_PATH = $(addprefix $(ADAPTERS_ROOT)/,$(FC_DEP_IPS_ADAPTERS))

FC_DEP_IPS_ADAPTERS_LINKING_PATH = $(patsubst %,-L$(ADAPTERS_ROOT)/%,$(FC_DEP_IPS_ADAPTERS))

nullstring :=
space := $(nullstring) #
FC_DEP_IPS_ADAPTERS_RUNTIME_PATH = -Wl,-rpath=$(subst $(space),:,$(addprefix '$$ORIGIN'/$(ADAPTERS_ROOT)/,$(FC_DEP_IPS_ADAPTERS)))
FC_DEP_IPS_ADAPTERS_FINAL_LIBS = $(FINAL_LIBS) $(FC_DEP_IPS_ADAPTERS_LINKING_PATH) $(FC_DEP_IPS_ADAPTERS_RUNTIME_PATH) $(FC_DEP_IPS_ADAPTES_NAME_FOR_LINKING)
FC_DEP_IPS_ADAPTERS_FINAL_INC = $(FINAL_PRODUCT_INC) $(FC_GENERIC_ADAPTERS)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

.PHONY: dummygoal
dummygoal: ;

vpath %.so $(CORE_ROOT) $(FC_DEP_ALL_IPS_FULL_PATH) $(CURR_ADAPTER_ROOT)
vpath %.a $(CORE_ROOT) $(FC_DEP_ALL_IPS_FULL_PATH) $(CURR_ADAPTER_ROOT)
.LIBPATTERNS := $(foreach path,$(CORE_ROOT) $(FC_DEP_ALL_IPS_FULL_PATH) $(CURR_ADAPTER_ROOT),$(path)/lib%.so $(path)/lib%.a)

define -lDenverCore
	+$(MAKE) -C $(CORE_ROOT) -- $(@)
endef

define -l10Gs_LAD10Gig
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/10Gs/ -- $(@)
endef

define -l1Gs_LAD1Gig
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/1Gs/ -- $(@)
endef

define -l40Gs
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/$(@:-l%=%)/ -- $(@)
endef

define -lBMC
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/$(@:-l%=%)/ -- $(@)
endef

define -lCPM
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/$(@:-l%=%)/ -- $(@)
endef

define -lGeneric
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/$(@:-l%=%)/ -- $(@)
endef

define -lRdma
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Eth/$(@:-l%=%)/ -- $(@)
endef

define -lGenericSwitch
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Switch/Generic/ -- $(@)
endef

define -lHLPsFamily
	+$(MAKE) -C $(ADAPTERS_ROOT)/IPs/Switch/HLPs/ -- $(@)
endef

define -lGenericFCsFamily
	+$(MAKE) -C $(ADAPTERS_ROOT)/FCs/Generic/ -- $(@)
endef

define -lMstDesignFCsFamily
	+$(MAKE) -C $(ADAPTERS_ROOT)/FCs/MstDesign/ -- $(@)
endef


-l%:
	$(call $@)

-lGenericSwitch -lGeneric -l1Gs_LAD1Gig -l10Gs_LAD10Gig -l40Gs -lBMC -lHLPsFamily -lCPM -lRdma: $(CORE_LIBS)
-lGenericFCsFamily -lMstDesignFCsFamily: $(FC_DEP_IPS_ADAPTES_NAME_FOR_LINKING) $(CORE_LIBS)

.DELETE_ON_ERROR:

%Adapters.mk: ;
%Makefile: ;

include $(DENVER_ROOT)dotd.mk

ifeq ($(.DEFAULT_GOAL),dummygoal)
  .DEFAULT_GOAL :=
endif
