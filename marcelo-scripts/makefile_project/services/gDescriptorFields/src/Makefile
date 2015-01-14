sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities -lDescriptorFields -lgUtilities

INC_PVM := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
INC := -I../inc/ $(INC_PVM)
all_lib_inc := $(INC) $(shell wx-config --cxxflags)

include ../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all clean
default: all

all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
