NAME := Utilities
TARGET_SO=lib$(NAME).so

targets_so := ../$(TARGET_SO)
targets_so_preq := -lUtilities
include ../../preq.mk

LIBS := -lpcap -lc -lpci -lz -lboost_thread -lboost_filesystem -ldl

ifeq ($(SVOS),1)
 LIBS += -L/lib/x86_64-linux-gnu
endif

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp, %.o, $(sources))

CXXFLAGS := -fPIC -Wall -g

.PHONY: all default
default: all

all: $(TARGET_SO)

$(TARGET_SO): $(OBJECTS)
	$(CXX) -shared -Wl,-soname,$(TARGET_SO) -o ../$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	/sbin/ldconfig -n ../
clean: 
	rm -f *.o *.out $(includes) ../lib*.so ../lib*.so.*

$(eval $(auto_prerequisite_gen))
