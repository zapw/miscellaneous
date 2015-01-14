OBJECTS:= CFtdiWrapper.o

CXXFLAGS:=-Wall -g -Wextra -fPIC 

TARGET := libgenesys_proxy
TARGET_SO:=$(TARGET).so.0.0

targets_so := $(TARGET).so
targets_so_preq := -lftd2xx
set_inc := -lgenesys_proxy

include ../../../preq.mk

LIBS := -ldl -lpthread -lc -lz

.PHONY: all install 
all: $(TARGET).so

$(TARGET).so: $(OBJECTS)
	$(CXX) -shared -Wl,-soname,$(TARGET).so -o $(TARGET_SO) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	ln -fs $(TARGET).so.0.0 $(TARGET).so

install:
	sudo cp $(TARGET_SO) /usr/lib64/
	sudo ln -fs /usr/lib64/$(TARGET).so.0.0 /usr/lib64/$(TARGET).so
	sudo mkdir -p /usr/include/fpga_access/
	sudo cp ../inc/CFtdiWrapper.h /usr/include/fpga_access/
	sudo /sbin/ldconfig -l /usr/lib64/$(TARGET_SO)

clean:
	rm -f $(TARGET_SO) *.o $(includes) $(TARGET).so

sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
