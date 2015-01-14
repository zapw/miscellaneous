sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

all_lib_inc := -I../inc 
set_inc := -lUtilities
include ../../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all

default: all
all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
