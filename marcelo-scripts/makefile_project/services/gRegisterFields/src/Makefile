NAME := gRegisterFields

LIB_OBJS :=	gBitSegment.o\
		gRegisterFields.o\
		gRegistersMap.o
REGGY_OBJS :=	Reggy.o

HFILES :=	gBitSegment.h\
		gRegisterFields.h\
		gRegistersMap.h

TARGET_SO := ../lib$(NAME).so
TARGET_ST := ../lib$(NAME).a

targets := Reggy
targets_so := $(TARGET_SO)
targets_so_preq := -lUtilities -lRegisterFields
targets_preq := -lUtilities -lRegisterFields

INC_PVM := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
INC := -I../inc/ $(INC_PVM)
all_lib_inc := $(INC) $(shell wx-config --cxxflags)

include ../../preq.mk

ifeq ($(shell  wx-config --version | cut -c1),2)
WXWIDGET_LIBS := $(shell wx-config --libs)
else
WXWIDGET_LIBS :=  $(shell wx-config --libs all)
endif

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS := -ldl $(WXWIDGET_LIBS) $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

DIR_NAME := registers
SWIG_LIBS := $(LIBS) -L.. -l$(NAME)
SWIGFLAGS := -Wall

REG_CFG_FILES_PATH := ../cfg/
REG_CFG_TAR_NAME := ConfigFiles.tar

ifeq ($(shell uname -m), x86_64)
SHARE_LIBS_DIR := /usr/lib64
else
SHARE_LIBS_DIR := /usr/lib
endif

SHARE_INC_DIR := /usr/include/services

.PHONY: default all clean clean_lib
default: all

all: $(TARGET_SO) $(TARGET_ST) Reggy

$(TARGET_SO): $(LIB_OBJS)
	$(CXX) -shared -o $(TARGET_SO) $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)

Reggy: $(LIB_OBJS) $(REGGY_OBJS)
	$(CXX) $(CPPFLAGS) -o $@ $(REGGY_OBJS) $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(TARGET_ST): $(LIB_OBJS)
	ar -rcs $(TARGET_ST) $(LIB_OBJS)

install:
	@echo $(SHARE_LIBS_DIR)
	sudo mkdir -p $(SHARE_LIBS_DIR)/$(NAME)
	sudo cp $(TARGET_SO) $(TARGET_ST) $(SHARE_LIBS_DIR)
	sudo /sbin/ldconfig -l $(SHARE_LIBS_DIR)/lib$(NAME).so
	sudo mkdir -p $(SHARE_INC_DIR)/$(NAME)
	sudo cp ../inc/*.h $(SHARE_INC_DIR)/$(NAME)
	sudo cp ./Reggy /usr/bin

clean:
	rm -f *.o $(includes) Reggy ../*.so* ../*.a

clean_lib:
	sudo rm -rf $(SHARE_LIBS_DIR)/*lib$(NAME)* $(SHARE_INC_DIR)/$(NAME) /usr/bin/Reggy

sources := $(patsubst %.o,%.cpp,$(LIB_OBJS) $(REGGY_OBJS))

$(eval $(auto_prerequisite_gen))
