default: all

NAME := services/
SHARE_INC_DIR := /usr/include/
CONFIG_GLOBAL_PATH:= $(SHARE_INC_DIR)/services/ConfigFiles

ifdef SVOS
DESTDIR ?= /
endif

#create symbolic link for old boost version on redhat 6
ifneq '$(shell /bin/rpm -qf /etc/redhat-release 2>/dev/null| /bin/grep redhat-release-server-6)' ''
 nop := $(shell sudo ln -sf /usr/lib64/libboost_thread-mt.so /usr/lib64/libboost_thread.so)
endif

NON_GUI_PROJECTS := UTILITIES XMLPARSER COMNET DESCS REGS EXEC_ENGINE PCKTS PACKETGENERATORI SCAPYPACKETGENERATOR ADMINQ HMC EVENTS IXIA JDSU LECROY DUMMY_SERVICE ANUE NVMFIELDS SYNTHETICTEST IOSF FPGA  MAINTEST APPS
GUI_PROJECTS := GREGS gUTILS gDESCS

#If we compile for SVOS, exclude all GUI projects
ifdef SVOS
  ALL := $(NON_GUI_PROJECTS)
else
  SUDO := sudo
  ALL := $(NON_GUI_PROJECTS) $(GUI_PROJECTS)
endif

all: $(ALL)

NO_TESTS: UTILITIES_NT DESCS_NT REGS_NT GREGS_NT PCKTS_NT gUTILS gDESCS ADMINQ_NT FPGA

install_no_tests_dirs := DescriptorFields RegisterFields gRegisterFields OnRingElements Utilities gUtilities \
	gDescriptorFields AdminQueue FpgaAccess #PacketGeneratorI ScapyPacketGenerator HMCFields  XMLParsers Events NVMFields

install_dirs := DescriptorFields RegisterFields IosfFields OnRingElements Utilities ExecutionEngine PacketGeneratorI \
	ScapyPacketGenerator AdminQueue HMCFields XMLParsers Events Ixia Jdsu LeCroy DummyService Anue \
	CommuneNet NVMFields SyntheticTest apps FpgaAccess

clean_dirs := DescriptorFields RegisterFields IosfFields OnRingElements Utilities ExecutionEngine \
	MainTest PacketGeneratorI ScapyPacketGenerator AdminQueue HMCFields XMLParsers Events Ixia Jdsu LeCroy \
	DummyService Anue CommuneNet NVMFields SyntheticTest apps FpgaAccess

clean_lib_dirs := DescriptorFields/src RegisterFields/src gRegisterFields/src OnRingElements/src Utilities ExecutionEngine PacketGeneratorI \
	ScapyPacketGenerator AdminQueue HMCFields/src XMLParsers Events Ixia Jdsu LeCroy DummyService Anue gUtilities \
	gDescriptorFields CommuneNet NVMFields SyntheticTest IosfFields/src apps FpgaAccess 

clean_lib_dirs := $(patsubst %,clean_lib-%,$(clean_lib_dirs))
clean_dirs := $(patsubst %,clean-%,$(clean_dirs))
install_dirs := $(patsubst %,install-%,$(install_dirs))
install_no_tests_dirs := $(patsubst %,install-%,$(install_no_tests_dirs))

.PHONY: all $(ALL) install install_no_tests clean_lib clean clean_old $(clean_lib_dirs) $(clean_dirs) $(install_dirs) $(install_no_tests_dirs)

UTILITIES: UTILITIES_NT
DESCS: DESCS_NT
PCKTS: PCKTS_NT
HMC: HMC_NT
REGS: REGS_NT
GREGS: GREGS_NT
ADMINQ: ADMINQ_NT

CONFIG_FILES:
	@printf "\n%s\n" "********************* build ConfigFiles directory **************************"
	$(MAKE) -C ConfigFiles/

APPS:  UTILITIES_NT COMNET XMLPARSER EXEC_ENGINE
	@printf "\n%s\n" "********************* build apps directory **************************"
	$(MAKE) -C apps/

MAINTEST: PACKETGENERATORI SCAPYPACKETGENERATOR UTILITIES DESCS REGS PCKTS ADMINQ NVMFIELDS HMC IXIA EVENTS SYNTHETICTEST IOSF
	@printf "\n%s\n" "********************* build MainTest library **************************"
	$(MAKE) -C MainTest/
 	
SYNTHETICTEST: UTILITIES_NT HMC_NT XMLPARSER DESCS_NT PCKTS_NT
	@printf "\n%s\n" "********************* build CommuneNet library **************************"
	$(MAKE) -C SyntheticTest/

COMNET: UTILITIES_NT XMLPARSER
	@printf "\n%s\n" "********************* build CommuneNet library **************************"
	$(MAKE) -C CommuneNet/

DESCS: UTILITIES_NT
	@printf "\n%s\n" "********************* build DescriptorFields library **************************"
	$(MAKE) -C DescriptorFields/

REGS: UTILITIES_NT
	@printf "\n%s\n" "********************* build RegisterFields library **************************"
	$(MAKE) -C RegisterFields/
IOSF: UTILITIES_NT
	@printf "\n%s\n" "********************* build RegisterFields library **************************"
	$(MAKE) -C IosfFields/

GREGS: UTILITIES_NT REGS_NT
	@printf "\n%s\n" "********************* build gRegisterFields library **************************"
	$(MAKE) -C gRegisterFields/

PCKTS: UTILITIES_NT DESCS_NT
	@printf "\n%s\n" "********************* build PcktDescDB library **************************"
	$(MAKE) -C OnRingElements/

TEST: UTILITIES_NT DESCS_NT REGS_NT GREGS_NT
	@printf "\n%s\n" "********************* build TEST library**************************"
	$(MAKE) -C Test/

UTILITIES:
	@printf "\n%s\n" "********************* build UTILITIES library**************************"
	$(MAKE) -C Utilities/

PACKETGENERATORI: UTILITIES_NT REGS_NT
	@printf "\n%s\n" "********************* build PACKETGENERATORI library**************************"
	$(MAKE) -C PacketGeneratorI/

FPGA:
	@printf "\n%s\n" "********************* build FpgaAccess library**************************"
	$(MAKE) -C FpgaAccess/


SCAPYPACKETGENERATOR: UTILITIES_NT PACKETGENERATORI
	@printf "\n%s\n" "********************* build ScapyPacketGenerator library**************************"
	$(MAKE) -C ScapyPacketGenerator/

ADMINQ: UTILITIES_NT
	@printf "\n%s\n" "********************* build AdminQueue library**************************"
	$(MAKE) -C AdminQueue/ 

HMC: UTILITIES_NT
	@printf "\n%s\n" "********************* build HMCFields library**************************"
	$(MAKE) -C HMCFields/

NVMFIELDS: UTILITIES_NT
	@printf "\n%s\n" "********************* build NVMFields library**************************"
	$(MAKE) -C NVMFields/

gUTILS: UTILITIES_NT
	@printf "\n%s\n" "********************* build gUtilities library**************************"
	$(MAKE) -C gUtilities/
gDESCS: UTILITIES_NT  DESCS_NT gUTILS
	@printf "\n%s\n" "********************* build gDescriptorFields library**************************"
	$(MAKE) -C gDescriptorFields/

EXEC_ENGINE: UTILITIES_NT COMNET XMLPARSER
	@printf "\n%s\n" "********************* build ExecutionEngine directory **************************"
	$(MAKE) -C ExecutionEngine/

UTILITIES_NT: 
	@printf "\n%s\n" "********************* build UTILITIES library**************************"
	$(MAKE) -C Utilities/ NO_TESTS
DESCS_NT: UTILITIES_NT
	@printf "\n%s\n" "********************* build DescriptorFields library **************************"
	$(MAKE) -C DescriptorFields/ NO_TESTS
REGS_NT: UTILITIES_NT
	@printf "\n%s\n" "********************* build RegisterFields library **************************"
	$(MAKE) -C RegisterFields/ NO_TESTS
GREGS_NT: UTILITIES_NT REGS_NT
	@printf "\n%s\n" "********************* build gRegisterFields library **************************"
	$(MAKE) -C gRegisterFields/ NO_TESTS

PCKTS_NT: UTILITIES_NT DESCS_NT
	@printf "\n%s\n" "********************* build PcktDescDB library **************************"
	$(MAKE) -C OnRingElements/ NO_TESTS

ADMINQ_NT: UTILITIES_NT
	@printf "\n%s\n" "********************* build AdminQueue library**************************"
	$(MAKE) -C AdminQueue NO_TESTS
HMC_NT: UTILITIES_NT
	@printf "\n%s\n" "********************* build AdminQueue library**************************"
	$(MAKE) -C HMCFields NO_TESTS


XMLPARSER: UTILITIES_NT
	@printf "\n%s\n" "********************* build AdminQueue library**************************"
	$(MAKE) -C XMLParsers

EVENTS: UTILITIES_NT
	@printf "\n%s\n" "********************* build EVENTS library**************************"
	$(MAKE) -C Events

IXIA: UTILITIES_NT
	@printf "\n%s\n" "********************* build IXIA library**************************"
	$(MAKE) -C Ixia


ANUE: UTILITIES_NT
	@printf "\n%s\n" "********************* build ANUE library**************************"
	$(MAKE) -C Anue

JDSU: UTILITIES_NT
	@printf "\n%s\n" "********************* build JDSU library**************************"
	$(MAKE) -C Jdsu

LECROY: UTILITIES_NT
	@printf "\n%s\n" "********************* build LECROY library**************************"
	$(MAKE) -C LeCroy

DUMMY_SERVICE: UTILITIES_NT
	@printf "\n%s\n" "********************* build Dummy Service library**************************"
	$(MAKE) -C DummyService

install_no_tests: $(install_no_tests_dirs) | $(SHARE_INC_DIR)/$(NAME)


.PHONY: $(clean_lib_dirs) $(clean_dirs) $(install_dirs)

ifndef SVOS
install_dirs += install-gRegisterFields install-gUtilities install-gDescriptorFields
endif

ifdef SVOS
install: $(install_dirs) | $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
$(DESTDIR)$(SHARE_INC_DIR)/$(NAME):
	install -d $@
else
install: $(install_dirs) | $(SHARE_INC_DIR)/$(NAME)
$(SHARE_INC_DIR)/$(NAME):
	-sudo mkdir -p $@

clean_dirs += clean-gRegisterFields clean-gUtilities clean-gDescriptorFields
endif

clean: $(clean_dirs)

.PHONY: remove
clean_lib: $(clean_lib_dirs) remove

remove:
	sudo rm -rf $(CONFIG_GLOBAL_PATH)
	
$(clean_lib_dirs):
	$(MAKE) -C $(@:clean_lib-%=%) clean_lib

$(clean_dirs):
	$(MAKE) -C $(@:clean-%=%) clean
	
$(sort $(install_dirs) $(install_no_tests_dirs)):
	$(MAKE) -C $(@:install-%=%) install
	
clean_old:
	./clean_services
