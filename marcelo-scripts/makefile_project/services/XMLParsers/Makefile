NAME := XMLParsers

ifdef SVOS
DESTDIR ?= /
endif

TARGET_SO := lib$(NAME).so.0.0
TARGET := lib$(NAME).so
targets_so := $(TARGET)
targets_so_preq := -lUtilities 

include ../preq.mk

EXT_LIBS := -lxerces-c -lpcap -lc -lpci -lz -lboost_system -ldl
PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS := -L/usr/lib64 -L/usr/local/lib/ $(EXT_LIBS) $(PVM_LIBS) 

DBG := -g
FLAGS := -fPIC -Wall #-DRCF_USE_BOOST_ASIO -Wno-deprecated

DIRS := src

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

OBJECTS := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))

CLEANDIRS := $(DIRS:%=clean-%)

.PHONY:	$(DIRS) $(CLEANDIRS) clean default all

default: all

all: lib$(NAME).so

clean: $(CLEANDIRS)
	rm -f lib$(NAME).so *.o $(includes) $(TARGET_SO) $(TARGET)

lib$(NAME).so: $(OBJECTS)
	$(CXX) -shared -Wl,-soname,lib$(NAME).so -o ./$(TARGET_SO) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	/sbin/ldconfig -n ./

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	$(MAKE) -C $@

install: 
ifdef SVOS
	install -d $(DESTDIR)/usr/include/services/$(NAME)/
	install -m 0444 inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/
	install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
else
	sudo mkdir -p /usr/include/services/$(NAME)/
	sudo cp inc/*.h /usr/include/services/$(NAME)/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
endif

clean_lib: 
	sudo rm -rf /usr/include/services/$(NAME)
	sudo rm -rf $(LIBS_DIR)/*lib$(NAME)*

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
