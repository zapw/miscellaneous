sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

TESTS := hello hello_other hello_other1  ClientGroups1 ClientGroups ServerGroups ClientGroups2 ClientGroups3
targets := $(TESTS)
targets_preq := -lUtilities

all_lib_inc := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
include ../../preq.mk

DRIVER_LIBS :=  -lpcap -lc   -lpci -lz -lboost_system  -ldl 
LIBS := -lcppunit  $(DRIVER_LIBS) -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3

CXXFLAGS := -fPIC -Wall -g

.PHONY: default
default: $(OBJECTS) $(TESTS)

$(TESTS): %: %.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(@) $< $(LDFLAGS) $(LDLIBS) $(LIBS)

.PHONY: default
default: $(TESTS)

clean:  
	rm -f   *.o *.out $(includes) $(TESTS) 

$(eval $(auto_prerequisite_gen))
