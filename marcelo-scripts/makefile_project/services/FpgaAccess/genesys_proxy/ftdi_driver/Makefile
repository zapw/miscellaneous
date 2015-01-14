LIBS = -lusb-1.0
TARGET_SO = libFtdiUsbDriver.so# ftdi usb driver

set_inc := -lDriverApi 

include ../../../preq.mk


ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif

CDBG_FLAGS = -rdynamic -ggdb
CXXFLAGS = $(CDBG_FLAGS)  -c -Wall -Werror  -fpic -Wno-write-strings
# Note: main.cpp is purposely not included in this list
sources := \
	ftdiDriver2232c.cpp \
	ftdi.cpp
	
OBJECTS = $(sources:.cpp=.o)

.PHONY: all default install clean
all: default

default: $(TARGET_SO)

$(TARGET_SO): $(OBJECTS)
	$(CXX) -g -shared -fpic  $(OBJECTS) -o $(TARGET_SO) $(LIB_DIR) $(LIBS) -lm

install:
	@echo $(LIBS_DIR)
	sudo mkdir -p $(INC_DIR)
	sudo cp $(TARGET_SO) $(LIBS_DIR)
	sudo cp *.h $(INC_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
	sudo cp config/40-ftdi.rules /etc/udev/rules.d/

clean:
	rm -f $(TARGET_SO) *.o *.a *.so $(includes)


$(eval $(auto_prerequisite_gen))
