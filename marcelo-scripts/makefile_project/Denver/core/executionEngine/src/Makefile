include ../../Core.mk

all_lib_inc := $(CORE_EXECENGINE_INC)

sources := $(wildcard *.cpp)
objects := $(sources:%.cpp=%.o)

ifdef SVOS
all_lib_inc += -I/usr/include/svos/ -I/usr/include/svos/sv/
CXXFLAGS += -DSVOS
endif

.PHONY: default all clean
default: all

all: $(objects)

CXXFLAGS += $(DBG)

clean:	
	rm -f *.o .*.d $(includes)

$(eval $(auto_prerequisite_gen))
