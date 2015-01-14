ADAPTER_NAME:=IPs/Eth/BMC
include ../../../../../../../Adapters.mk

PROGRAM := smbfpga
LITEIGNITE_LIB := -lFpgaRegisterAccessApi -lUtilities $(PVM_LIB)
LDFLAGS := $(LITEIGNITE_LIB) $(WXLIBS)
all_lib_inc := $(FINAL_INFRA_INC) $(WXCXXFLAGS)

sources := $(wildcard *.cpp)
objects := $(patsubst %.cpp,%.o,$(sources))

CXXFLAGS += -rdynamic $(DBG) -Wwrite-strings -fpermissive

.PHONY: default all clean
default: $(PROGRAM)
all: $(PROGRAM)

$(PROGRAM): $(objects)
	$(CXX) -rdynamic -o $@ $(objects) $(LDFLAGS) -lftd2xx

clean:
	rm -f *.o .*.d $(includes) $(PROGRAM)

$(eval $(auto_prerequisite_gen))
