################################################################################
# 
# Copyright(c) 1999 - 2010 Intel Corporation. All rights reserved.
# 
# Makefile for building sv driver tools 
#

#
################################################################################

# support Fedora and SUSE in the same $(MAKE)file
ifeq "$(wildcard /etc/SuSE-release )" ""
	DIS="Fedora"
else
	DIS="SUSE"
endif

ifeq ($(shell uname -m),i686)
	PLATFORM="32"
else
	PLATFORM="64"
endif

OS_NAME := $(shell cat /etc/redhat-release | cut -d " " -f1)

ifeq ($(DIS),"Fedora")
	FEDORA_VERSION= $(shell cat /etc/redhat-release | cut -d" " -f3)
#	IS_REDHAT= $(shell cat /etc/redhat-release | grep "Red Hat")
#	ifeq ($(IS_REDHAT),"")
#		COMPILE_LATEST= 0
#	else
	COMPILE_LATEST= $(shell expr $(FEDORA_VERSION) \>= 18)
#	endif
else
	COMPILE_LATEST=0 
endif

IS_PPC= $(shell uname -r | grep ppc)
ifneq "$(IS_PPC)" ""
	COMPILE_LATEST=0
endif


phony_targets := SVSCRIPTS \
	SVDT \
	MAGLAN \
	BITCONV \
	COMMON \
	CC_TEST_APP \
	AQ_TEST_APP \
	PE_TEST_APP \
	READ_CSR \
	WRITE_CSR \
	LLDPAGENT \
	NVM_PCIe_Loader\
	PORT_DISCOVERY\
	BOARD_ALIVENESS\
	LINK_APP\
	PCI_ACC\
	CPU_AFFINITY \
	SRIOV_CTRL\

phony_targets += $(shell echo $(phony_targets)  | tr '[:upper:]' '[:lower:]' ) 
install_targets = svdt maglan bitconv lldp_agent Nvm_PCIe_Loader\
	 port_discovery board_aliveness\
	 scripts aq_app read_csr write_csr\
	 link_app pci_acc cpu_affinity sriov

clean_targets = test_app test_app_vf iwarp/iwarp-test carbon_copy pci_acc\
	aq_app lldp_agent Nvm_PCIe_Loader port_discovery board_aliveness\
	scripts read_csr write_csr svdt/libtecla svdt maglan bitconv common\
	carbon_copy link_app pci_acc cpu_affinity sriov

ifeq ($(OS_NAME),Red) #redhat
else
clean_targets += nvm_burner
endif

.PHONY: all default $(phony_targets) $(install_targets) $(clean_targets)

default: all
	#@echo "compile latest $(COMPILE_LATEST) a$(IS_PPC)b why fedora version $(FEDORA_VERSION) redhat $(IS_REDHAT) ?"
	#@echo "build for $(PLATFORM) bit platform"


all: $(phony_targets)	


svscripts: SVSCRIPTS
SVSCRIPTS: COMMON
	@echo
	@echo "********************* build scripts environment *****************************"
	@echo
	$(MAKE) -C scripts

svst:SVDT
SVDT: COMMON
	@echo
	@echo "********************* build svdt application *****************************"
	@echo
	$(MAKE) -C svdt

nvm_burner:NVM_BURNER
NVM_BURNER:
ifeq ($(OS_NAME),Red) #redhat
	@echo
	@echo "********************* skip build nvm_burner application and lib on red hat *********************"
	@echo
else
	@echo
	@echo "********************* build nvm_burner application and lib **************************"
	@echo
	#$(MAKE) -C nvm_burner
endif


maglan: MAGLAN
MAGLAN: BITCONV COMMON
	@echo
	@echo "********************* build Maglan application *****************************"
	@echo
	$(MAKE) -C maglan

bitconv: BITCONV
BITCONV:
	@echo
	@echo "********************* build bitconv application *****************************"
	@echo
	$(MAKE) -C bitconv

common: COMMON
COMMON:
	@echo
	@echo "********************* build common libs *****************************"
	@echo
	$(MAKE) -C common

NETCONF:
	@echo
	@echo "********************* build net config application *****************************"
	@echo
	$(MAKE) -C netconf

lldpagent: LLDPAGENT
LLDPAGENT:
	@echo
	@echo "********************* build lldp agent application *****************************"
	@echo
	$(MAKE) -C lldp_agent

test_app:TEST_APP
TEST_APP:
	@echo
	@echo "********************* build generic test application *****************************"
	@echo
	$(MAKE) -C tools/test_app

TEST_APP_VF:
	@echo
	@echo "********************* build vf test application *****************************"
	@echo
	$(MAKE) -C test_app_vf

CC_TEST_APP:
	@echo
	@echo "********************* build test app for carbon copy *****************************"
	@echo
	$(MAKE) -C carbon_copy

AQ_TEST_APP:
	@echo
	@echo "********************* build test app for admin queue *****************************"
	@echo
	$(MAKE) -C aq_app

PE_TEST_APP:
	@echo
	@echo "********************* build test app for pci express *****************************"
	@echo
	$(MAKE) -C pci_acc

IWARP_TEST_APP:
	@echo
	@echo "********************* build iwarp test app *****************************"
	@echo
	$(MAKE) -C iwarp/iwarp-test



read_csr:READ_CSR
READ_CSR:
	@echo
	@echo "********************* build read-csr app *****************************"
	@echo
	$(MAKE) -C read_csr

write_csr:WRITE_CSR
WRITE_CSR:
	@echo
	@echo "********************* build write-csr app *****************************"
	@echo
	$(MAKE) -C write_csr

NVM_PCIe_Loader:
	@echo
	@echo "********************* build NVM_PCIe_Loader app *****************************"
	@echo
	$(MAKE) -C Nvm_PCIe_Loader

port_discovery:PORT_DISCOVERY
PORT_DISCOVERY:
	@echo
	@echo "********************* build port_discovery app *****************************"
	@echo
	$(MAKE) -C port_discovery

board_aliveness:BOARD_ALIVENESS
BOARD_ALIVENESS:
	@echo
	@echo "********************* build board_aliveness app *****************************"
	@echo
	$(MAKE) -C board_aliveness

LINK_APP:
	@echo
	@echo "********************* build link_app app *****************************"
	@echo
	$(MAKE) -C link_app

PCI_ACC:
	@echo
	@echo "********************* build pci_acc app *****************************"
	@echo
	$(MAKE) -C pci_acc

CPU_AFFINITY:
	@echo
	@echo "********************* build cpu_affinity app *****************************"
	@echo
	$(MAKE) -C cpu_affinity

SRIOV_CTRL:
	@echo
	@echo "********************* build cpu_affinity app *****************************"
	@echo
	$(MAKE) -C sriov


#we do this so each directory will be a seperate target to run in parallel when doing clean/install
install_targets := $(install_targets:%=%_suffix)
clean_targets := $(clean_targets:%=%_suffix)

install: $(install_targets)
clean: $(clean_targets)

#Use sort to remove duplicates and strip the suffix "_suffix" from the directories, this will run in parallel for each directory
$(sort $(clean_targets) $(install_targets)):
	$(MAKE) -C $(@:%_suffix=%) $(MAKECMDGOALS)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
