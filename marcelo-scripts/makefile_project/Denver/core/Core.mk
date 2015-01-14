#######################			Compilation flags	###########################
###########################################################################################
DBG := -g
CXXFLAGS := $(CXXFLAGS)
CXXFLAGS += -fPIC -Wall -rdynamic
%.o: CPPFLAGS += $(all_lib_inc)


#######################		   	Global Defs        	###########################
###########################################################################################

CORE_ROOT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

CORE_ADAPTERS_DIR = adapters
CORE_INFRA_DIR = $(CORE_ROOT_DIR)infrastructure
CORE_SYNTHETIC_DIR = $(CORE_INFRA_DIR)SyntheticTest
CORE_EXEC_ENGINE_DIR = $(CORE_ROOT_DIR)executionEngine
#ifdef SVOS
CORE_EXEC_ENGINE_ROCKET_DIR = $(CORE_ROOT_DIR)executionEngine/rocket
#ROCKET_EXEC_ENGINE_INC_DIRECTIVE = -I$(CORE_EXEC_ENGINE_ROCKET_DIR)/inc 
#endif
CORE_TESTS_DIR = $(CORE_ROOT_DIR)tests
CORE_BIN_DIR = $(CORE_ROOT_DIR)bin
CORE_USR_INCLUDE := /usr/include
CORE_SERVICES_DIR := $(CORE_USR_INCLUDE)/services
CORE_SVDRIVER_DIR := $(CORE_USR_INCLUDE)/sv_driver

BIN_NAME = Denver
TARGET_NAME = DenverCore
TARGET_SO = lib$(TARGET_NAME).so.0.0

#######################			Includes Defs		###########################
###########################################################################################
CORE_DRIVER_LIBS := -lDriverApi -lPciApi -lpcap -lc -lpci -lz -lboost_system -ldl -lboost_thread #-lCpmApi
BIN_DRIVER_LIBS = $(CORE_DRIVER_LIBS) -lDriverIwarpApi -lOnRingElements
ROOT_DRIVER_LIBS = $(CORE_DRIVER_LIBS) -lboost_filesystem
ROOT_EXT_LIBS = -lUtilities -lDescriptorFields -lRegisterFields -lSyntheticTest -lHMCFields -lOnRingElements -lXMLParsers -lEvents -lIxia -lJdsu -lAnue -lLeCroy -lNVMFields -lCommuneNet -L/usr/share/pvm3/lib/LINUXX86_64/ -lpvm3 -lgpvm3 -lPacketGeneratorI -lExecutionEngine
ROOT_GLOBAL_LIBS =  $(ROOT_DRIVER_LIBS) $(ROOT_EXT_LIBS)


BIN_LIBS_LINKING_PATH = -L../ -Wl,-rpath,'$$ORIGIN'/$(CORE_ROOT_DIR)
BIN_LIBS =  $(BIN_LIBS_LINKING_PATH)  -lDenverCore -lUtilities -lCommuneNet -lHMCFields -L /usr/share/pvm3/lib/LINUXX86_64/ -lpvm3 -lDescriptorFields -lRegisterFields -lAdminQueue -lOnRingElements -lPacketGeneratorI  -lNVMFields -lScapyPacketGenerator $(BIN_DRIVER_LIBS) -lxerces-c -lFpgaRegisterAccessApi -lEvents -lIxia -lJdsu -lLeCroy -lAnue -lExecutionEngine
CORE_BASE_INC = -I$(CORE_INFRA_DIR)/inc/ -I$(CORE_INFRA_DIR)/$(CORE_ADAPTERS_DIR)/inc/ -I$(CORE_INFRA_DIR)/SyntheticTest/inc/ -I$(CORE_SVDRIVER_DIR)/api/ -I$(CORE_SERVICES_DIR)/SyntheticTest/ -I$(CORE_SERVICES_DIR)/PacketGeneratorI/  -I$(CORE_SERVICES_DIR)/Utilities/ -I$(CORE_SERVICES_DIR)/DescriptorFields/ -I$(CORE_SERVICES_DIR)/RegisterFields/  -I$(CORE_SERVICES_DIR)/AdminQueue/  -I$(CORE_SERVICES_DIR)/OnRingElements/ -I$(CORE_SERVICES_DIR)/XMLParsers/  -I$(CORE_SERVICES_DIR)/Events/ -I$(CORE_SERVICES_DIR)/Ixia/ -I$(CORE_SERVICES_DIR)/Jdsu/ -I$(CORE_SERVICES_DIR)/LeCroy/ -I$(CORE_SERVICES_DIR)/Anue/ -I$(CORE_SERVICES_DIR)/NVMFields/ -I$(CORE_SERVICES_DIR)/HMCFields/  -I$(CORE_SERVICES_DIR)/ExecutionEngine

CORE_GLOBAL_INC = $(CORE_BASE_INC) -I$(CORE_SVDRIVER_DIR)/pci/ -I$(CORE_SERVICES_DIR)/CommuneNet/ -I/usr/share/pvm3/include/ #$(CPM_INFA_INC)

CORE_INFRA_INC = $(CORE_GLOBAL_INC) -I$(CORE_USR_INCLUDE)/ -I/usr/include/fpga_access/ # core/infrastructure/src

CORE_EXECENGINE_INC = $(CORE_GLOBAL_INC) -I$(CORE_USR_INCLUDE)/ -I$(CORE_EXEC_ENGINE_DIR)/inc -I/usr/include/fpga_access/   # core/executionEngine/src
#ifdef SVOS
CORE_EXECENGINE_INC += -I$(CORE_EXEC_ENGINE_ROCKET_DIR)/inc
#endif
CORE_TESTS_INC = $(CORE_GLOBAL_INC) -I$(CORE_TESTS_DIR)/inc  -I/usr/include/fpga_access/    # core/tests/src
CORE_BIN_INC = $(CORE_GLOBAL_INC) -I$(CORE_EXEC_ENGINE_DIR)/inc -I$(CORE_EXEC_ENGINE_ROCKET_DIR)/inc -I$(CORE_TESTS_DIR)/inc -I/usr/include/fpga_access/ # core/bin
CORE_ROOT_INC = $(CORE_BASE_INC) -I$(CORE_EXEC_ENGINE_DIR)/inc/ # core/

CPM_LIB_DIR = $(CORE_SVDRIVER_DIR)/cmp/api/lib/
CPM_INFA_INC = -I$(CPM_LIB_DIR)


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

.PHONY: dummygoal
dummygoal: ;

define -l$(TARGET_NAME)
	+$(MAKE) -C $(CORE_ROOT_DIR) -- -l$(TARGET_NAME)
endef

-l%:
	$(call $@)

vpath %.so $(CORE_ROOT) 
vpath %.a $(CORE_ROOT)

.LIBPATTERNS := $(addprefix $(CORE_ROOT_DIR),lib%.so lib%.a)

#prevents implicit rule look-ups for Makefile.
Makefile: ;
.DELETE_ON_ERROR:

%Core.mk: ;

include $(CORE_ROOT_DIR)../dotd.mk

ifeq ($(.DEFAULT_GOAL),dummygoal)
  .DEFAULT_GOAL :=
endif
