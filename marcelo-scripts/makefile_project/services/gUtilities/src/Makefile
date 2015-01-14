sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

WXWIDGET_FLAGS := $(shell wx-config --cxxflags)
set_inc := -lUtilities -lgUtilities
all_lib_inc := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/ $(WXWIDGET_FLAGS)
include ../../preq.mk

CXXFLAGS := -fPIC -Wall -g

.PHONY: default all clean
default: all

all: $(OBJECTS)     

clean:
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
