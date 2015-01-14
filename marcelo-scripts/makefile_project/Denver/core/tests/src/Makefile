include ../../Core.mk

all_lib_inc := $(CORE_TESTS_INC)

ifdef SVOS
all_lib_inc += -I/usr/include/svos/ -I/usr/include/tcl8.5/
CXXFLAGS += -DSVOS
endif


sources := $(wildcard *.cpp)
objects := $(sources:%.cpp=%.o)

.PHONY: default all clean
default: all

all: $(objects)

CXXFLAGS += $(DBG)

clean:	
	rm -f *.o .*.d $(includes)

$(eval $(auto_prerequisite_gen))
