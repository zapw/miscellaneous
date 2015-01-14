include ../../../Core.mk

.PHONY: all default

all_lib_inc := $(CORE_EXECENGINE_INC)

sources := $(wildcard *.cpp)
objects := $(patsubst %.cpp,%.o,$(sources))

all_lib_inc += -I/usr/include/svos/ -I/usr/include/svos/sv/
CXXFLAGS += -DSVOS $(DBG)

default: all
all: $(objects)

clean:
	rm -f *.o .*.d $(includes)

$(eval $(auto_prerequisite_gen))
