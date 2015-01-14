NAME := Reggy

LIB_OBJS := Reggy.o
WXWIDGET_LIBS := $(shell wx-config --libs)

targets := $(NAME)
targets_preq := -lUtilities -lRegisterFields -lgRegisterFields
set_inc := -lDescriptorFields

all_lib_inc := $(shell wx-config --cppflags)
include ../../preq.mk

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS := -ldl $(WXWIDGET_LIBS) $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

ifeq ($(shell uname -m), x86_64)
SHARE_LIBS_DIR := /usr/lib64
else
SHARE_LIBS_DIR := /usr/lib
endif

SHARE_INC_DIR := /usr/include

.PHONY: default all
default: all
all: $(NAME)
	
$(NAME): $(LIB_OBJS)
	$(CXX) $(CPPFLAGS) -o $@ $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)

install:

clean:
	rm -f *.o $(includes) Reggy
	
sources := $(LIB_OBJS:.o=.cpp)

$(eval $(auto_prerequisite_gen))
