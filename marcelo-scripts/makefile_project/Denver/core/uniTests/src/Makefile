include ../../Core.mk

NAME := CoreCppUnitTest
OBJECTS := InfraStructureTest.o uniTestMain.o
HFILES := InfraStructureTest.h

DRIVER_LIBS := -lDriverApi -lDriverIwarpApi -lpcap -lc -lpci -lz -lboost_system -ldl -lUtilities -lDescriptorFields -lRegisterFields -lOnRingElements -lAdminQueue -lEvents -lIxia -lFpgaRegisterAccessApi -lScapyPacketGenerator -lxerces-c
LIBS_PATH := -L../../ -Wl,-rpath,'$$ORIGIN'/../../
LIBS := $(LIBS_PATH) -lcppunit -lDenverCore -lNVMFields $(DRIVER_LIBS)

INC_EXT_LIB := -I/usr/include/sv_driver/api/ -I/usr/include/sv_driver/pci/ -I/usr/include/services/SyntheticTest/ -I/usr/include/services/CommuneNet/ -I/usr/share/pvm3/include/ -I/usr/include/services/PacketGeneratorI/  -I/usr/include/services/Utilities/ -I/usr/include/services/DescriptorFields/  -I/usr/include/services/AdminQueue/ -I/usr/include/services/RegisterFields/  -I/usr/include/services/OnRingElements/ -I/usr/include/services/Events/ -I/usr/include/services/Ixia/ -I/usr/include/services/XMLParsers/ -I/usr/include/services/NVMFields/  -I/usr/include/services/HMCFields/ -I/usr/include/services/ExecutionEngine/ -I/usr/include/fpga_access/
all_lib_inc := -I../inc/ -I../../infrastructure/inc/ -I../../infrastructure/SyntheticTest/inc/ -I../../infrastructure/adapters/inc/ $(INC_EXT_LIB)
CXXFLAGS = -fPIC -Wall -g

.PHONY: all default
default: $(NAME)
all: $(NAME)

$(NAME): $(OBJECTS) -l$(TARGET_NAME)
	$(CXX) $(CXXFLAGS) -o $(NAME) $(OBJECTS) $(LIBS)

install: ;

clean:  
	rm -f *.o $(NAME) .*.d $(includes)

sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
