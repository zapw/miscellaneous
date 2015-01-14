include ../Core.mk

all_lib_inc := $(CORE_BIN_INC)

ifdef SVOS
DESTDIR ?= /
endif

sources := $(wildcard *.cpp)
objects := $(sources:%.cpp=%.o)

ifdef SVOS
all_lib_inc += -I/usr/include/svos/ -I/usr/include/svos/sv/
CXXFLAGS += -DSVOS
endif

.PHONY: default all clean
default: all
all: $(BIN_NAME)

CXXFLAGS += $(DBG)

$(BIN_NAME): main.o -l$(TARGET_NAME)
	$(CXX) $(BIN_LIBS) -o $(BIN_NAME) main.o -rdynamic

ifdef SVOS
install:
	install -d $(DESTDIR)/usr/bin
	install $(BIN_NAME) $(DESTDIR)/usr/bin/
endif

clean:	
	rm -f $(BIN_NAME) *.o .*.d $(includes)

$(eval $(auto_prerequisite_gen))
