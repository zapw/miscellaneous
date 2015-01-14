sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities -lAnue
all_lib_inc := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/ -I/usr/include/tcl8.5 
include ../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all
default: all

all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
