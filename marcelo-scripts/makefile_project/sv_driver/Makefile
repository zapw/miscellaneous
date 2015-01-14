################################################################################
# 
# Copyright(c) 1999 - 2010 Intel Corporation. All rights reserved.
# 
# Makefile for building sv driver framework
#

#
################################################################################
# Keep running this makefile with SU privs (for install target), but not on SVOS.

#To compile without services, use "pmake/make NO_SERVICES=1" or "export NO_SERVICES=1". (Applicable to any dependencies of this Makefile.)

# Determine which OS and version is running
OS := $(shell awk -F= '/^(NAME|VERSION_ID)=/ { print  $$2}' /etc/os-release 2>/dev/null)
OS_NAME := $(word 1, $(OS))
OS_VERSION := $(word 2, $(OS))
OS_PLATFORM := $(shell uname -m)

$(warning Compiling on OS=$(OS_NAME) VERSION=$(OS_VERSION) PLATFORM=$(OS_PLATFORM))

ifneq ($(OS_NAME), "Intel SVOS")
SUDO := sudo
endif

# support Fedora and SUSE in the same makefile
ifeq "$(wildcard /etc/SuSE-release )" ""
	DIS :="Fedora"
else
	DIS :="SUSE"
endif

ifeq ($(OS_PLATFORM),i686)
	PLATFORM :="32"
else
	PLATFORM := "64"
endif


ifeq ($(DIS),"Fedora")
	COMPILE_LATEST := $(shell expr $(OS_VERSION) \>= 18)
else
	COMPILE_LATEST := 0 
endif

IS_PPC := $(shell uname -r | grep ppc)
ifneq "$(IS_PPC)" ""
	COMPILE_LATEST := 0
endif

phony_targets := DRIVERS API MISC_DRIVER REMOTING JTAGACCESS APPS CPPUNIT\
	 I40E IWNES I200E I200EVF IXGBE IXGBC IGB E1000 PCI\
	TERARAM SXP TEST_APP TEST_APP_VF CC_TEST_APP FPGA IXGBE_FPGA\
	 SVDT MAGLAN BITCONV TOOLS COMMON FVL CPK NIANTIC_FPGA

phony_targets += $(shell echo $(phony_targets)  | tr '[:upper:]' '[:lower:]' )

.PHONY: default all check_targets checkall_targets check checkall\
 debug load default drivers unitestCppUnit $(phony_targets)

default: all
	@echo "build for $(PLATFORM) bit platform"

debug:
	@printf "%s\n" "FEDORA_VERSION = $(OS_VERSION)" \
	"COMPILE_LATEST = $(COMPILE_LATEST)" \
	"IS REDHAT =$(IS_REDHAT)"

load: 
	./load.sh iwnes


drivers:DRIVERS

all:	DRIVERS API MISC_DRIVER REMOTING JTAGACCESS TOOLS #APPS CPPUNIT

RDMA: I40E IWNES API

ifeq ($(DIS), "SUSE")
DRIVERS: IXGBE IGB 
else
DRIVERS: I200E I200EVF I40E IXGBE IXGBC IGB IWNES #E1000
endif

MISC_DRIVER: PCI #TERARAM SXP

APPS:	TEST_APP TEST_APP_VF CC_TEST_APP

FPGA:   API IXGBE_FPGA IGB SVDT MAGLAN BITCONV CPPUNIT

iwarp:IWARP

IWARP: COMMON REMOTING
	$(MAKE) -C api/iwarp/src

fvl:FVL
FVL:	API REMOTING PCI I40E TOOLS 

cpk:CPK
CPK:	API REMOTING PCI I200E TOOLS 

tools:TOOLS
TOOLS: API PCI IWARP
	@printf "\n%s\n" "********************* build driver tools ***************************"
	$(MAKE) -C tools

maglan:MAGLAN
MAGLAN:	PCI API IWARP
	$(MAKE) -C tools/maglan

svdt:SVDT
SVDT:	
	$(MAKE) -C tools/svdt

api:API
API: REMOTING
	@echo
	@echo "********************* build driver api library ***************************"
	@echo
	$(MAKE) -C api

REMOTING:
	@printf "\n%s\n" "********************* build driver remoting library ***************************"
	$(MAKE) -C remoting RCF

jtagaccess: JTAGACCESS
JTAGACCESS:
ifeq ($(PLATFORM), "64")
  ifeq ($(COMPILE_LATEST),1)
	@echo
	@echo "********************* build jtag access library ********************"
	@echo
	$(MAKE) -C jtagAccess
  else
	@echo "********************* skipping jtag access library ********************"
  endif
endif

i200e:I200E
I200E:
	@printf "\n%s\n" "********************* build i200e driver *********************************"
	$(MAKE) -C i200e

i200evf:I200EVF
I200EVF:I200E
	@printf "\n%s\n" "********************* build i200evf driver *********************************"
	$(MAKE) -C i200evf

i40e:I40E
I40E:
	@printf "\n%s\n" "********************* build i40e driver *********************************"
	$(MAKE) -C i40e

ixgbe:IXGBE
IXGBE:
	@printf "\n%s\n" "********************* build ixgbe driver *********************************"
	$(MAKE) -C ixgbe

NIANTIC_FPGA:
	@printf "\n%s\n" "********************* build NIANTIC FPGA ixgbe driver *********************************"
	$(MAKE) -C ixgbe/ CFLAGS_EXTRA=-DNIANTIC_FPGA_SUPPORT
	
ixgbc:IXGBC
IXGBC:
	@printf "\n%s\n" "********************* build ixgbc driver *********************************"
	$(MAKE) -C ixgbc
	
igb:IGB	
IGB:
	@printf "\n%s\n" "********************* build igb driver *********************************"
	$(MAKE) -C igb

pci:PCI
PCI: API
	@printf "\n%s\n" "********************* build generic pci driver *********************************"
	$(MAKE) -C pci

sxp:SXP
SXP:
	@printf "\n%s\n" "********************* build sxp driver for soc fpga sideband *************************"
	$(MAKE) -C sxp

e1000:E1000
E1000:
	@printf "\n%s\n" "********************* build e1000 driver *********************************"
	$(MAKE) -C e1000

iwnes:IWNES
IWNES:
	@printf "\n%s\n" "********************* build ne020 driver *********************************"
	$(MAKE) -C nes

teraram:TERARAM
TERARAM:
	@printf "\n%s\n" "********************* build teraram driver *********************************"
	$(MAKE) -C teraram

unitestCppUnit: CPPUNIT
CPPUNIT:
	@printf "\n%s\n" "********************* build cppunit tests *****************************"
	$(MAKE) -C unitestCppUnit



check_targets = unitestCppUnit
checkall_targets = unitestCppUnit 

check_targets := $(check_targets:%=%_suffix)
checkall_targets := $(checkall_targets:%=%_suffix)

check: $(check_targets)

checkall: $(checkall_targets)

$(sort $(check_targets) $(checkall_targets)): 
	$(MAKE) -C $(@:%_suffix=%) $(filter check checkall,$(MAKECMDGOALS))

clean_targets = api api/iwarp tools remoting ixgbe \
	ixgbc igb e1000 i40e i200e i200evf \
	nes teraram pci sxp pktgen

install_targets = api api/iwarp remoting tools pci #sxp

ifeq ($(PLATFORM), "64")
  ifeq ($(COMPILE_LATEST),1)
    install_targets += jtagAccess
    clean_targets += jtagAccess
  endif
endif

#we do this so each directory will be a seperate target to run in parallel when doing clean/install
install_targets := $(install_targets:%=%_suffix)
clean_targets := $(clean_targets:%=%_suffix)

.PHONY: install clean $(install_targets) $(clean_targets)

install: $(install_targets)
	sudo cp dlog /usr/bin
	./setsyslog.sh
	sudo mkdir -p /usr/share/sv_driver/status
	sudo chmod a+w /usr/share/sv_driver/status
	$(file >/usr/share/sv_driver/status/install_dir.cfg,$(CURDIR))
	#./scripts/remove_all_drivers.sh


clean: $(clean_targets) ;

#Use sort to remove duplicates and strip the suffix "_suffix" from the directories, this will run in parallel for each directory
$(sort $(clean_targets) $(install_targets)):
	$(MAKE) -C $(@:%_suffix=%) $(filter clean install,$(MAKECMDGOALS))

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:

#prevents implicit rule look-ups for Makefile.
Makefile: ;
