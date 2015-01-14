sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

TESTS := client.out BufferClient.out
targets := $(TESTS)
targets_preq := -lUtilities -lCommuneNet
all_lib_inc := -I../inc/ -I/usr/share/pvm3/include/

include ../../../preq.mk

CXXFLAGS := -fPIC -Wall -g

EXT_LIBS := -lz -lboost_thread -lboost_filesystem -ldl -lrt
LIBS := -L/usr/share/pvm3/lib/LINUXX86_64/ -lpvm3 -lgpvm3 $(EXT_LIBS)

.PHONY: default
default: $(TESTS)

$(TESTS): %.out: %.o
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(@) $< $(LDFLAGS) $(LDLIBS) $(LIBS)

clean:  
	rm -f *.o $(TESTS) $(includes)

$(eval $(auto_prerequisite_gen))
