###############################################################
#							
#  Makefile for Maglan (Graphical version of sv driver tool)
#                                                          
###############################################################
.DELETE_ON_ERROR:
PROGRAM := maglan
EXE := $(PROGRAM)
WXCONFIG := wx-config
WXCXXFLAGS := $(shell $(WXCONFIG) --cxxflags)
WXLIBS := $(shell $(WXCONFIG) --libs all)

ifeq ($(shell  $(WXCONFIG) --version | cut -c1),2)
	WXLIBS := $(shell $(WXCONFIG) --libs)
endif

USE_NEVADA := 0

OS_NAME := $(shell cat /etc/redhat-release | cut -d " " -f1)

ifeq ($(USE_NEVADA),1)
	DEFINES = \
		-DUSE_NEVADA

	INCLUDES_NEVADA := \
		-I../../../application/agent/inc\
		-I../../../application/common/inc
	
	AGENTDIR := ../../../application/agent/src
	COMMONDIR := ../../../application/common/src
	
	SOURCES_NEVADA := \
			$(AGENTDIR)/CPacket.cpp \
			$(AGENTDIR)/CTxPacket.cpp \
			$(AGENTDIR)/CTxPacketsDB.cpp \
			$(AGENTDIR)/CTxRingsParser.cpp \
			$(COMMONDIR)/CRootDir.cpp \
			$(COMMONDIR)/CGenericParser.cpp \
			$(COMMONDIR)/UtilFuncs.cpp \
			$(COMMONDIR)/CDOMTreeErrorReporter.cpp

	extras := ../../common/SvdtPackets.cpp
	
	LIBS_NEVADA := -lxerces-c
endif

INCLUDES := \
	-I../inc\
	-I../inc/DriverComponents\
	-I../inc/TreeControl\
	-I../../\
	-I../../../api/inc\
	-I../../../pci/api/inc\
	-I../../../pktgen/pktgen_lib/inc\
	-I../../common/\
	-I../../bitconv/\
	-I../\
	-I/usr/include/sv_driver/api\
	$(INCLUDES_NEVADA)

INCLUDES_SERVICES := \
	-I../../../../services/Utilities/inc\
	-I../../../../services/gUtilities/inc\
	-I../../../../services/RegisterFields/inc\
	-I../../../../services/DescriptorFields/inc\
	-I../../../../services/gDescriptorFields/inc\
	-I../../../../services/gRegisterFields/inc\
	-I../../../../services/FpgaAccess/duke_proxy\
	-I../../../../services/FpgaAccess/FpgaAccessApi\
	-I../../../../services/FpgaAccess/genesys_proxy/inc\
	-I../../../../services/FpgaAccess/veloce_proxy\
	-I../../../../services/FpgaAccess/FpgaAccessApi\
	-I/usr/include/services/Utilities/\
	-I/usr/include/services/gUtilities/\
	-I/usr/include/services/RegisterFields/\
	-I/usr/include/services/DescriptorFields/\
	-I/usr/include/services/gDescriptorFields/\
	-I/usr/include/services/gRegisterFields/\
        -I/usr/include/fpga_access\

LIBDIRS := -L../../../api/lib\
	-L../../../pci/api/src\

CPPFLAGS = $(WXCXXFLAGS) $(INCLUDES) $(DEFINES) $(GENERAL_DEFINES) -Wall -g
LIBS := -lDriverApi -lDriverIwarpApi -lPciApi -ldl $(LIBS_NEVADA) -lboost_system ../../../pktgen/bin/libpktgen.a
LIBS_SERVICES := -lUtilities -lRegisterFields -lgRegisterFields -lDescriptorFields -lgDescriptorFields -lgUtilities


SOURCES := 	SvdtMainFrame.cpp\
		SvdtChildFrame.cpp\
		SvdtDialogs.cpp\
		SvdtPhyDialogs.cpp\
		SvdtDialogsBackend.cpp\
		PciExpressDisplay.cpp\
		RingDescDisplay.cpp\
		RxRingDescDisplay.cpp\
		TxRingDescDisplay.cpp\
		EepromDisplay.cpp \
		SvdtNvmDisplay.cpp \
		MemoryMapDisplay.cpp \
		SvdtCsrEditor.cpp\
		SvdtBarEditor.cpp\
		SvdtIovCsrEditor.cpp\
		SvdtPhyEditor.cpp\
		SvdtMonitors.cpp\
		SvdtDialogEnableIov.cpp\
		SvdtDialogConfiguration.cpp\
		SvdtPacketCollectorDialog.cpp\
		SvdtMultipleTxPanel.cpp\
		MultipleRingsMonitor.cpp\
		MultipleTxMonitor.cpp\
		MultipleRxMonitor.cpp\
		SvdtTxRingDialogs.cpp\
		SvdtTxRingDialogsImp.cpp\
		ShellCommandDialog.cpp\
		ShellCommandDialogImp.cpp\
		PacketGenerationDisplay.cpp\
		PacketGenerationDisplayImp.cpp\
		TransmitConfigurationDialog.cpp\
		TransmitConfigurationDialogImp.cpp\
		ReceiveConfigurationDialog.cpp\
		ReceiveConfigurationDialogImp.cpp\
		InterruptVectorITRDialog.cpp\
		DialogReadPhysicalMemory.cpp\
		GenericGauge.cpp\
		WorkingGauge.cpp\
		DriverComponents/ISvdtDriverComponent.cpp\
		DriverComponents/ISvdtBaseRing.cpp\
		DriverComponents/ISvdtRingContainer.cpp\
		DriverComponents/SvdtPci.cpp\
		DriverComponents/SvdtDevice.cpp\
		DriverComponents/SvdtPort.cpp\
		DriverComponents/SvdtPF.cpp\
		DriverComponents/SvdtVf.cpp\
		DriverComponents/SvdtVm.cpp\
		DriverComponents/SvdtRxContainer.cpp\
		DriverComponents/SvdtTxContainer.cpp\
		DriverComponents/SvdtInterruptVectorContainer.cpp\
		DriverComponents/SvdtRxRing.cpp\
		DriverComponents/SvdtTxRing.cpp\
		DriverComponents/SvdtInterruptVector.cpp\
		TreeControl/SvdtTreeViewModel.cpp\
		TreeControl/VisualTree.cpp\
		TreeControl/SvdtTreeBuilder.cpp\
		TreeControl/VisualDevice.cpp\
		TreeControl/VisualPort.cpp\
		TreeControl/VisualPf.cpp\
		TreeControl/VisualVf.cpp\
		TreeControl/VisualRxContainer.cpp\
		TreeControl/VisualRxRing.cpp\
		TreeControl/VisualTxContainer.cpp\
		TreeControl/VisualTxRing.cpp\
		TreeControl/VisualInterruptVectorContainer.cpp\
		TreeControl/VisualInterruptVector.cpp\
		$(SOURCES_NEVADA)

		
SOURCES_SERVICES :=\
               PCIeRegisterProxy.cpp\
               TreeControl/VisualPCI.cpp\
               PciCapabilitiesTree.cpp\
               SvdtPciFrame.cpp\
               SvdtRegisterFields.cpp\
        SvdtgswPCIRegisterFileds.cpp\
        SvdtPCIRegisterFields.cpp\
        SvdtRegistersMap.cpp

LDFLAGS :=
ifeq ($(OS_NAME),Red) #redhat
       CPPFLAGS += -DNO_LITEIGNITE
else
       ifneq ($(NO_SERVICES),1)
           LIBS += -lFpgaRegisterAccessApi
	   libs_services := -lFpgaRegisterAccessApi
	   libpaths := $(patsubst %,../../../../services/FpgaAccess/%,duke_proxy genesys_proxy/src veloce_proxy)
	   nullstring :=
           LDFLAGS += -Wl,-rpath-link=$(subst $(nullstring) ,:,$(libpaths))
       endif
endif

ifeq ($(NO_SERVICES),1)
CPPFLAGS += -DNO_LITEIGNITE
else
CPPFLAGS += -DSERVICES
LIBS += $(LIBS_SERVICES)
INCLUDES += $(INCLUDES_SERVICES)
SOURCES += $(SOURCES_SERVICES)
LIBDIRS += $(foreach lib,$(LIBS_SERVICES),$(patsubst -l%,-L../../../../services/%,$(lib))) -L../../../../services/FpgaAccess/FpgaAccessApi
libs_services += $(LIBS_SERVICES)
endif

OBJECTS := $(SOURCES:.cpp=.o)  # expands to list of object files

LDFLAGS += -rdynamic $(LIBDIRS) $(LIBS) $(WXLIBS)

extras += ../../bitconv/BitConverterFlex.cpp\
	../../common/DriverEvents.cpp\
	../../common/PacketCollector.cpp

extra_objects_nodir = $(patsubst %.cpp,%.o,$(notdir $(extras)))
extra_objects = $(patsubst %.cpp,%.o,$(extras))

.PHONY: all
all: $(PROGRAM)

vpath %.so ../../../api/lib ../../../pci/api/src $(foreach lib,$(LIBS_SERVICES),$(patsubst -l%,../../../../services/%,$(lib))) ../../../../services/FpgaAccess/FpgaAccessApi
vpath %.o ../../bitconv ../../common
vpath %.a ../../../pktgen

$(PROGRAM): $(HFILES) $(OBJECTS) libDriverIwarpApi.so libDriverApi.so libPciApi.so $(extra_objects) bin/libpktgen.a $(libs_services)
	$(CXX) $(WXCXXFLAGS) $(CPPFLAGS) $(INCLUDES) -o $@ $(OBJECTS) $(extra_objects)  $(LDFLAGS) 

bin/libpktgen.a:
	$(MAKE) -C ../../../pktgen $@

BitConverterFlex.o:
	$(MAKE) -C ../../bitconv

DriverEvents.o PacketCollector.o SvdtPackets.o:
	$(MAKE) -C ../../common $@

libDriverIwarpApi.so: libDriverApi.so
	$(MAKE) -C ../../../api/iwarp lib

libDriverApi.so:
	$(MAKE) -C ../../../api/src lib

libPciApi.so:
	$(MAKE) -C ../../../pci/api/src

-lUtilities:
	$(MAKE) -C ../../../../services/$(@:-l%=%)/src $(@:-l%=lib%.so)

-lRegisterFields -lgRegisterFields -lDescriptorFields:
	$(MAKE) -C ../../../../services/$(@:-l%=%)/src ../$(@:-l%=lib%.so)

-lgDescriptorFields -lgUtilities:
	$(MAKE) -C ../../../../services/$(@:-l%=%) $(@:-l%=lib%.so)

-lFpgaRegisterAccessApi:
	$(MAKE) -C ../../../../services/FpgaAccess/FpgaAccessApi $(@:-l%=lib%.so)

-lRegisterFields: -lUtilities
-lgRegisterFields: -lUtilities -lRegisterFields
-lDescriptorFields: -lUtilities
-lgDescriptorFields: -lgUtilities -lUtilities -lDescriptorFields
-lgUtilities: -lUtilities

install:
	sudo cp -f maglan /usr/bin/maglan2

clean:
	$(RM) -f $(OBJECTS) $(EXE) $(includes)

run:
	./$(PROGRAM)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(SOURCES),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CXX) $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $(WXCXXFLAGS)  $(INCLUDES) $< > $@

# Include .d makefile file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
