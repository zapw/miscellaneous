sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

set_inc := -lUtilities -lExecutionEngine -lCommuneNet -lXMLParsers
all_lib_inc := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include

ifdef SVOS
all_lib_inc += -I/usr/include/svos/ -I/usr/include/svos/sv/
endif

include ../../preq.mk
 
CXXFLAGS := -fPIC -Wall -g

ifdef SVOS
	CXXFLAGS += -DSVOS
endif

.PHONY: default all
default: all

all: $(OBJECTS)     

clean:  
	rm -f *.o $(includes)

$(eval $(auto_prerequisite_gen))
