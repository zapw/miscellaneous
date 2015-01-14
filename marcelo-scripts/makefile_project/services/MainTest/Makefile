NAME := uniTestMain

onringelements := ../OnRingElements/Tests/CRingUnitTest.o ../OnRingElements/Tests/PcktDescDBUnitTest.o

adminqueue := ../AdminQueue/Tests/CAdminQueueSample.o ../AdminQueue/Tests/CAdminQueueUnitTest.o

descriptorfields := ../DescriptorFields/Tests/CDescriptorFieldsUnitTest.o ../DescriptorFields/Tests/CDescsInterfaceUnitTest.o

events := ../Events/Tests/CEventsTest.o

hmcfields := ../HMCFields/Tests/CHMCFieldsUnitTest.o

ixia := ../Ixia/Tests/CIxiaSample.o ../Ixia/Tests/CIxiaUniTest.o

nvmfields := ../NVMFields/tests/CNVMMapUnitTest.o ../NVMFields/tests/CNVMSample.o ../NVMFields/tests/CNVMUnitTest.o

packetgeneratori :=  ../PacketGeneratorI/tests/CPayloadSample.o ../PacketGeneratorI/tests/CPayloadTest.o

registerfields := ../RegisterFields/Tests/CRegisterFieldsUnitTest.o ../RegisterFields/Tests/CRegisterMapUnitTest.o\
 ../RegisterFields/Tests/PCIeRegTest.o\
 ../RegisterFields/Tests/PhyRegTest.o\
 ../RegisterFields/Tests/CAllRegistersTest.o

scapypacketgenerator := ../ScapyPacketGenerator/Test/CScapyUnitTest.o ../ScapyPacketGenerator/Test/CScapySample.o 

utilities := ../Utilities/tests/CbitSegmentTest.o ../Utilities/tests/CBufferBitsTest.o ../Utilities/tests/CBufferFieldsDemo.o\
 ../Utilities/tests/CBufferFieldsTest.o\
 ../Utilities/tests/CBufferSample.o\
 ../Utilities/tests/CBufferUnitTest.o\
 ../Utilities/tests/CCfgPathTest.o\
 ../Utilities/tests/CDescriptorUnitTest.o\
 ../Utilities/tests/CHexStrTest.o\
 ../Utilities/tests/CIpV4AddressSample.o\
 ../Utilities/tests/CIpV4AddressUnitTest.o\
 ../Utilities/tests/CIpV6AddressSample.o\
 ../Utilities/tests/CIpV6AddressUnitTest.o\
 ../Utilities/tests/CMacAddressSample.o\
 ../Utilities/tests/CMacAddressUnitTest.o\
 ../Utilities/tests/COutputServerProxyUnitTest.o\
 ../Utilities/tests/CSharedSetUpTest.o\
 ../Utilities/tests/CStopWatchSample.o\
 ../Utilities/tests/CStopWatchTest.o\
 ../Utilities/tests/CUtilFuncsSample.o\
 ../Utilities/tests/CUtilFuncsUnitTest.o\
 ../Utilities/tests/CWatchDogTest.o\
 ../Utilities/tests/CWriteFileSample.o\
 ../Utilities/tests/CColorTest.o\
 ../Utilities/tests/CPowerManagementTest.o\
 ../Utilities/tests/CDateUnitTest.o\
 ../Utilities/tests/CServiceFuncsUnitTest.o

iosfields := ../IosfFields/Tests/CIosfInterfaceUnitTest.o

synthetictest := ../SyntheticTest/Tests/CTestFlowParserUnitTest.o

OBJECTS = $(onringelements) $(adminqueue) $(descriptorfields) $(events) $(hmcfields) $(ixia) $(nvmfields) $(packetgeneratori) $(registerfields)\
	 $(scapypacketgenerator) $(utilities) $(iosfields) $(synthetictest)

targets := $(NAME)
targets_preq := -lUtilities -lDescriptorFields -lRegisterFields -lOnRingElements -lAdminQueue -lNVMFields -lHMCFields -lIxia -lEvents -lSyntheticTest -lIosfFields\
	-lScapyPacketGenerator -lPacketGeneratorI

include  ../preq.mk

DRIVER_LIBS :=  -lpcap -lc -lpci -lz -lboost_system -ldl -lxerces-c
PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS := -L/usr/lib64 -L/usr/local/lib -lcppunit -lpthread  $(DRIVER_LIBS) $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

.PHONY: default install clean
default: $(NAME)

$(NAME): $(NAME).o $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(NAME) $(NAME).o $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

define template
.PHONY: $$(dir $$(firstword $(1)))
$(1): | $$(dir $$(firstword $(1))) ;

$$(dir $$(firstword $(1))):
	$$(MAKE) -C $$@
endef

$(foreach obj,$(value OBJECTS),$(eval $(call template,$(obj))))

../Utilities/tests/: -lUtilities
../OnRingElements/Tests/: -lDescriptorFields -lUtilities -lOnRingElements
../DescriptorFields/Tests/: -lUtilities -lDescriptorFields
../Events/Tests/: -lUtilities -lEvents
../NVMFields/tests/: -lUtilities -lNVMFields
../PacketGeneratorI/tests/: -lRegisterFields -lUtilities -lPacketGeneratorI
../RegisterFields/Tests/: -lUtilities -lRegisterFields
../HMCFields/Tests/: -lUtilities -lHMCFields
../ScapyPacketGenerator/Test/: -lPacketGeneratorI -lUtilities -lScapyPacketGenerator
../SyntheticTest/Tests/: -lSyntheticTest -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements
../AdminQueue/Tests/: -lUtilities -lAdminQueue
../Ixia/Tests/: -lUtilities -lIxia
../IosfFields/Tests/: -lUtilities -lIosfFields

install:

clean:  
	rm -f ./$(NAME) $(NAME).o
