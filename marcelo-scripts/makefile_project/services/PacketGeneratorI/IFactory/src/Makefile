sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities
all_lib_inc := -I../inc/ -I../../IPackets/inc -I../../ILayers/inc -I../../Payload/inc
include ../../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all
default:all

all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
