.DELETE_ON_ERROR:
CPPFLAGS = -std=c++0x -ggdb -c -Wall
PROJ_NAME = svDriverUnitTester

LIBS := -ldl -lcppunit -lDriverApi -lpci -lz -lboost_system -lrt -lDriverIwarpApi -lPciApi -lJtagAccess -lvarparamtest -ldriverutestutils
LIB_DIR := -L../../api/lib/ -L../varparamtest/lib -L../utils/lib -L/usr/lib64/ -L/usr/local/lib
INCLUDE_DIR := -I../inc -I../../api/inc -I../../pci/api/inc -I../../pktgen/pktgen_lib/inc \
        -I../../jtagAccess/inc -I../../api/iwarp/inc -I/usr/include/sv_driver/api/iwarp \
       -I../varparamtest/inc -I../varparamtest/param/inc -I../utils/inc \
       -I/usr/local/include  -I/usr/include/sv_driver/api

ifneq ($(NO_SERVICES),1)
CPPFLAGS += -DSERVICES
LIBS += -lUtilities -lDescriptorFields
INCLUDE_DIR += -I../../../services/Utilities/inc -I../../../services/DescriptorFields/inc /usr/include/services/Utilities -I/usr/include/services/DescriptorFields
endif

SOURCES := \
	RdmaTestSuit.cpp \
	TransmissionTestSuit.cpp \
	ResetBmeTestSuit.cpp \
	GetContextTestSuit.cpp \
	SvdTxCqTestSuit.cpp \
	SvdThreadsTestSuit.cpp \
	SvdRxApiTestSuit.cpp \
	SvdTxApiTestSuit.cpp \
	SvdExpectedResultsTestSuit.cpp \
	AdminQueueTestSuit.cpp \
	MailBoxQueueTestSuit.cpp \
	SvdInterruptsTestSuit.cpp \
	SvdPciTestSuit.cpp \
	SvdGenericTestSuit.cpp \
	CSvdAdminQueueEventsTest.cpp \
	SvdMemoryTestSuit.cpp \
	SriovTestSuit.cpp \
	SvdNvmTestSuit.cpp \
	SvdAdminQueueTestSuit.cpp \
	IwarpAlivenessTest.cpp \
	HostInterfaceTestSuit.cpp \
	DriverConfigTestSuit.cpp \
	SvdTxDblqTestSuit.cpp \
	ResetSriov.cpp \
	SvdAviyaSandbox.cpp


COMMON_OBJECTS := \
       UnitTestsMain.o\
       BaseTestSuit.o\
       Utilities.o


OBJECTS := $(SOURCES:.cpp=.o)


vpath %.o ../bin
vpath %.test ../bin

tests := $(filter-out IwdStagTestSuit.test SvdJtagAccessTestSuit.test SvdFcoeApiTestSuit.test,$(patsubst %.cpp,%.test,$(SOURCES)))

libs := libDriverApi.so libDriverIwarpApi.so libPciApi.so libJtagAccess.so libvarparamtest.so libdriverutestutils.so
.PHONY: all default
all: default

default: $(PROJ_NAME) $(tests)

$(PROJ_NAME): $(OBJECTS) $(COMMON_OBJECTS) $(libs)
	$(CXX) -o $@ $(CPPFLAGS) $(OBJECTS) $(LIB_DIR) $(LIBS)
	mv $@ ../bin

$(tests): %.test: %.o $(libs) $(COMMON_OBJECTS)
	$(CXX) -o $@ $(CPPFLAGS) $< $(COMMON_OBJECTS) $(LIB_DIR) $(LIBS)
	mv $@ ../bin

.cpp.o:
	$(CXX) $(INCLUDE_DIR) $(CPPFLAGS) $(LIBS) $< -o $@
	cp *.o ../bin

checkall:
	-../bin/$(PROJ_NAME)

check:
	-../bin/SvdInterruptsTestSuit.test

clean:
	rm -f $(includes)
	rm -rf $(PROJ_NAME)  *.o
	rm -rf ../bin/$(PROJ_NAME) ../bin/*.o ../bin/*.test


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
sources := $(patsubst %.o,%.cpp,$(COMMON_OBJECTS) $(OBJECTS))

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
	$(CXX) $(INCLUDE_DIR) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
