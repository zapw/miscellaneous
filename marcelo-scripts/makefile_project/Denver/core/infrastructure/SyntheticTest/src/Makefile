include ../../../Core.mk

sources := $(wildcard *.cpp)
objects := $(sources:%.cpp=%.o)

all_lib_inc := $(CORE_INFRA_INC)

CXXFLAGS += $(DBG)

.PHONY: default all clean
default: all

all: $(objects)

clean:	
	rm -f *.o .*.d $(includes)

$(eval $(auto_prerequisite_gen))
