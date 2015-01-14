sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities -lCommuneNet -lXMLParsers
all_lib_inc := -I../inc -I/usr/share/pvm3/include
include ../../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all
default: all

all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
