sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities -lHMCFields -lXMLParsers -lDescriptorFields -lOnRingElements -lSyntheticTest

all_lib_inc := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/

include ../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all
default: all
all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
