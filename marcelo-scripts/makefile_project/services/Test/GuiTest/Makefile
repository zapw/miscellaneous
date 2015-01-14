NAME := HelloWorld
LIB_OBJS := HelloWorld.o

targets := $(NAME).out
targets_preq := -lUtilities -lDescriptorFields -lRegisterFields -lgRegisterFields
LIBS := -ldl $(shell wx-config --libs)

CXXFLAGS := -fPIC -Wall -g
all_lib_inc := $(shell wx-config --cxxflags)

include ../../preq.mk

ifeq ($(shell uname -m), x86_64)
SHARE_LIBS_DIR := /usr/lib64
else
SHARE_LIBS_DIR := /usr/lib
endif

SHARE_INC_DIR := /usr/include

.PHONY: default all
default: all
all: $(NAME).out

$(NAME).out: $(LIB_OBJS)
	$(CXX) $(CPPFLAGS) -o $@ $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)

install: ;

clean:
	rm -f *.o *.out $(includes)

sources := $(LIB_OBJS:.o=.cpp)

$(eval $(auto_prerequisite_gen))
