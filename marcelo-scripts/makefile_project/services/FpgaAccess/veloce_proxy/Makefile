OBJECTS := SerialPort.o veloce_proxy.o
CXXFLAGS := -Wall -g -Wextra -fPIC
TARGET := libVeloceProxy
TARGET_SO := $(TARGET).so.0.0

targets := mymain
targets_preq := -lftd2xx

LIBS := -ldl -lpthread -lrt

include ../../preq.mk

.PHONY: all install clean
all: $(TARGET).so mymain

$(TARGET).so:  $(OBJECTS)
	$(CXX) -lz -shared -Wl,-soname,$(TARGET).so -o $(TARGET_SO) $(OBJECTS) -lc $(LIBS)
	ln -fs $(TARGET).so.0.0 $(TARGET).so

mymain: $(OBJECTS) main.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OBJECTS) main.cpp -o mymain $(LDFLAGS) $(LDLIBS) $(LIBS)
	
install:
	sudo cp $(TARGET_SO) /usr/lib64/
	sudo ln -fs /usr/lib64/$(TARGET).so.0.0 /usr/lib64/$(TARGET).so
	sudo mkdir -p /usr/include/fpga_access/
	sudo cp veloce_proxy.h /usr/include/fpga_access/
	sudo /sbin/ldconfig -l /usr/lib64/$(TARGET_SO)

clean:
	rm -f $(TARGET_SO) *.o $(includes) $(TARGET).so mymain

sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
