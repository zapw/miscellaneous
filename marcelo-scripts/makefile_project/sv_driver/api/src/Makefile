.DELETE_ON_ERROR:
# Set destination directory for installing to root by default
DESTDIR?=/#SVOS

# Determine which OS and version is running
OS_NAME := $(shell cat /etc/os-release | grep -w NAME | cut -d '=' -f2)
OS_VERSION := $(shell cat /etc/os-release | grep -w VERSION_ID | cut -d '=' -f2)
OS_PLATFORM := $(shell uname -m)

ifneq ($(OS_NAME), "Intel SVOS")
ifneq ($(OS_NAME), "Debian GNU/Linux")
SUDO := sudo
endif
endif

OBJECTS = 	DriverProxy.o \
		DriverMemBlock.o \
		DriverCsrBlock.o \
		DriverPhyBlock.o \
		DriverPciBlock.o \
		DriverPciExpressBlock.o \
		DriverEepromBlock.o \
		DriverNvmBlock.o \
		DriverTxIcacheBlock.o \
		DriverRxIcacheBlock.o \
		DriverTxBufferBlock.o \
		DriverRxBufferBlock.o \
		DriverExpansionRomBlock.o \
		DriverDevice.o \
		DriverPF.o \
		DriverPort.o \
		DriverPFLocal.o \
		DriverDeviceManager.o \
		Serializer.o \
		RemotingClientFactory.o \
		DriverPFRemote.o \
		DriverBaseRing.o \
		DriverTxRing.o \
		DriverRxRing.o \
		DriverTxCompletionQueue.o \
        	DriverDoorbellQueue.o \
		DriverConfig.o \
		DriverInterrupts.o \
		DriverExpectedResults.o \
		DriverNetConfig.o \
		DriverIovManager.o \
		DriverSriovApi.o \
		DriverFcoeManager.o \
		DriverAccessThread.o \
		DriverLogPipe.o \
		EnabledEventsList.o   \
		AQEnabledEventsList.o   \
		DriverEventPipe.o   \
		DriverPipeManager.o   \
		DriverQueryPipe.o  \
		DriverPacketCollectorPipe.o \
		DriverPacket.o \
		DriverRxPacket.o \
		DriverControlQueue.o \
		DriverAdminQueue.o \
		DriverAdminQueueI40e.o \
		DriverAdminQueueI200e.o \
		DriverMailBoxQueue.o \
		DriverHMC.o \
		DriverHostInterface.o \
		DriverMemoryServices.o \
		CRxPktInfo.o \
		DriverApiWrapper.o \
		DriverPacketCollectorPcap.o \
		DriverCarbonCopyManager.o \
		DriverSwitch.o \
		DriverLogger.o \
		DriverAPIFactory.o \
		DriverAPIPFFactory.o \
		DriverAPIVFonPFFactory.o \
		VFonPFDriverCsrBlock.o \
		VFonPFDriverPciBlock.o \
		VFonPFDriverPciExpressBlock.o \
		VFonPFDriverTxRing.o \
		VFonPFDriverRxRing.o \
		VFonPFDriverConfig.o \
		DriverCapabilities.o \
		DriverVsi.o \
		CPF.o \
		CTokenizer.o \
		CBWTable.o   \
		DriverAdminQueueEventPipe.o	\
		DriverMailBoxQueueEventPipe.o   \
		DriverSideBandQueueEventPipe.o  \
		DriverSideBandQueue.o   \
		DriverVF.o	\
		DriverVFLocal.o	\
		DriverBaseFunction.o \
		PfDriverInterrupts.o \
		VfDriverInterrupts.o \
		DriverPacketParser.o \
		DriverPSM.o
		

# dependency libraries
LIBS = -ldl -lpcap -lpthread -lboost_system ../../pktgen/bin/libpktgen.a

INC =	-I../inc \
	-I../iwarp/inc \
	-I../../sv_shared/ \
	-I../../nes/shared \
	-I../../i40e/shared \
	-I../../i200e/shared \
	-I../../remoting/Rcf/include \
	-I../../remoting/server\
	-I../../../services/Utilities/inc\
	-I../../../services/DescriptorFields/inc\
	-I../../../services/OnRingElements/inc\
	-I../../pktgen/pktgen_lib/inc\
	-I/usr/include/services/Utilities\
	-I/usr/include/services/DescriptorFields \
	-I/usr/include/services/OnRingElements\

DBG := -g
FLAGS := -pthread
FLAGS += -fPIC -Wall -DRCF_USE_BOOST_ASIO -Wno-deprecated -std=c++0x
FLAGS += -D__PTHREAD
FLAGS += -DDRIVER_API
FLAGS += -DIWNES
FLAGS += -DI40IW
FLAGS += -DI200E
FLAGS += -DDRIVER_API
FLAGS += -DDRIVER_API_CHECK_VERSION
FLAGS += -DUDA_ENABLED
FLAGS += -DCHECK_PARAMS
FLAGS += -DRDMA_VIRTCHNL
FLAGS += -DMKI_ROCE

FLAGS += -DCHECK_PARAMS
FLAGS += -DUDA_ENABLED
FLAGS += -DMKI_ROCE
FLAGS += -DSV_DRIVER

TARGET=libDriverApi.so.0.0
TARGET_SO=libDriverApi.so


CXXFLAGS := $(INC) $(FLAGS) $(DBG)

LDFLAGS := -L../../pktgen/bin
RCF_OBJ=../../remoting/Rcf/RCF.o

ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else 
ifeq ($(shell uname -m), ppc64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif
endif

extra_includes = ../inc/i40e_adminq_cmd.h ../inc/ice_adminq_cmd.h

vpath $(TARGET_SO) ../lib
vpath %.a ../lib
vpath bin/libpktgen.a ../../pktgen

.PHONY: default all lib stat

default: all

all: $(TARGET_SO) libDriverApi.a

lib: $(TARGET_SO)
stat: libDriverApi.a

../inc/i40e_adminq_cmd.h:
	ln -sf ../../i40e/shared/$(@F) ../inc/$(@F)
../inc/ice_adminq_cmd.h:
	ln -sf ../../i200e/shared/$(@F) ../inc/$(@F)

$(TARGET_SO): $(OBJECTS) $(RCF_OBJ) bin/libpktgen.a | $(extra_includes)
	$(CXX) $(RCF_OBJ) $(INC) $(LDFLAGS) -shared -Wl,-soname,$(TARGET_SO) -o ../lib/$(TARGET) $(OBJECTS) -lc $(LIBS)
	ln -sf $(TARGET) ../lib/$(TARGET_SO)

libDriverApi.a: $(OBJECTS) $(RCF_OBJ) | $(extra_includes)
	ar -rcs ../lib/libDriverApi.a $(OBJECTS) $(RCF_OBJ)

bin/libpktgen.a:
	$(MAKE) -C ../../pktgen $@

$(RCF_OBJ): 
	$(MAKE) -C ../../remoting RCF

install: $(extra_includes)
	@echo $(LIBS_DIR)
	sudo rm -rf /usr/include/sv_driver/api
	$(SUDO) install -d $(DESTDIR)$(LIBS_DIR)
	$(SUDO) install  ../lib/libDriverApi.a $(DESTDIR)$(LIBS_DIR)
	$(SUDO) install  ../lib/$(TARGET) $(DESTDIR)$(LIBS_DIR)
ifndef SVOS
	$(SUDO) /sbin/ldconfig -l $(DESTDIR)/$(LIBS_DIR)/$(TARGET)
endif
	$(SUDO) install -d $(DESTDIR)/usr/include/sv_driver/api/
	$(SUDO) install -m 0444 ../inc/*.h $(DESTDIR)/usr/include/sv_driver/api/
	$(SUDO) install -m 0444 ../../sv_shared/sv_version.h $(DESTDIR)/usr/include/sv_driver/api/
	$(SUDO) install -m 0444 ../../i40e/shared/i40e_adminq_cmd.h $(DESTDIR)/usr/include/sv_driver/api/
	$(SUDO) install -m 0444 ../../i200e/shared/ice_adminq_cmd.h $(DESTDIR)/usr/include/sv_driver/api/

#setuid:
#	chmod u+s ./testapi

clean:
	rm -f ../lib/*.so* ../lib/*.a *.o $(extra_includes) $(includes)

sources = $(wildcard *.cpp)

#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(INC) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
