MAIN_CPP := test_lib

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

TESTS := CScapyUnitTest\
	CScapySample
		
targets := $(MAIN_CPP).out $(TESTS:%=%.out)
targets_preq := -lUtilities -lPacketGeneratorI -lScapyPacketGenerator

include ../../preq.mk

DRIVER_LIBS :=  -lpcap -lc   -lpci -lz -lboost_system  -ldl 
LIBS := -lcppunit  $(DRIVER_LIBS)

CXXFLAGS := -fPIC -Wall -g

.PHONY: default
default:  $(MAIN_CPP).out $(TESTS:%=%.out)

$(MAIN_CPP).out: $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(TESTS:%=%.out): %.out: %.o $(MAIN_CPP).o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(@) $(@:%.out=%.o) $(MAIN_CPP).o $(LDFLAGS) $(LDLIBS) $(LIBS)

clean:  
	rm -f *.o *.out $(includes)

$(eval $(auto_prerequisite_gen))
