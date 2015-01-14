sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities -lRegisterFields
all_lib_inc := -I../inc/ -I../../ILayers/inc

include ../../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all
default: all
all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
