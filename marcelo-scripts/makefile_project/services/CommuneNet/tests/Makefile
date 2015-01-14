MAIN_CPP := test_lib

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))
 		
TESTS := CUinTest.out

targets := $(MAIN_CPP).out $(TESTS)
targets_preq := -lUtilities
all_lib_inc := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
include ../../preq.mk

DRIVER_LIBS := -lpcap -lc -lpci -lz -lboost_system -ldl 
LIBS := -lcppunit $(DRIVER_LIBS) $(SERVICES_LIBS) -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/  -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3

CXXFLAGS := -fPIC -Wall -g

.PHONY: default 
default: $(MAIN_CPP).out $(TESTS)
	
$(MAIN_CPP).out: $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(MAIN_CPP).out $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(TESTS): %.out: %.o $(MAIN_CPP).o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(@) $< $(MAIN_CPP).o $(LDFLAGS) $(LDLIBS) $(LIBS)

clean:  
	rm -f   *.o *.out $(includes)

$(eval $(auto_prerequisite_gen))
