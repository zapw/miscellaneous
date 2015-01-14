MAIN_CPP := uniTestMain

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))
 		
TESTS := CNVMUnitTest CNVMMapUnitTest CNVMSample
targets := $(MAIN_CPP).out $(TESTS:%=%.out)
targets_preq := -lUtilities -lNVMFields

include ../../preq.mk

DRIVER_LIBS := -lpcap -lc -lpci -lz -lboost_system  -ldl 
LIBS := -lcppunit $(DRIVER_LIBS)

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
FINAL_LIBS := $(LIBS) $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

.PHONY: default
default:  $(MAIN_CPP).out $(TESTS:%=%.out)

$(MAIN_CPP).out: $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

$(TESTS:%=%.out): %.out: %.o $(MAIN_CPP).o
	$(CXX)  $(CPPFLAGS) $(CXXFLAGS) -o $(@) $(@:%.out=%.o) $(MAIN_CPP).o $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

clean:
	rm -f *.o *.out $(includes)

$(eval $(auto_prerequisite_gen))
