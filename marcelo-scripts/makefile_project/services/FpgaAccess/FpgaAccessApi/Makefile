OBJECTS:= FpgaRegisterAccess.o\
	GenesysRegisterAccess.o\
	DukeRegisterAccess.o\
	VeloceRegisterAccess.o

CXXFLAGS :=-Wall -g -Wextra -fPIC 

TARGET := libFpgaRegisterAccessApi
TARGET_SO:=$(TARGET).so.0.0

targets_so := $(TARGET).so
targets_so_preq := -lftd2xx -lDukeProxy -lgenesys_proxy -lVeloceProxy

include ../../preq.mk

LIBS := -ldl -lpthread

.PHONY: all clean install
all: $(TARGET).so
	
$(TARGET).so: $(OBJECTS)
	$(CXX) -lz -shared -Wl,-soname,$(TARGET).so -o $(TARGET_SO) $(OBJECTS) -lc $(LDFLAGS) $(LDLIBS) $(LIBS)
	ln -fs $(TARGET).so.0.0 $(TARGET).so

clean:
	rm -f $(TARGET_SO) *.o $(includes) $(TARGET).so

install:
	sudo cp $(TARGET_SO) /usr/lib64/
	sudo ln -fs /usr/lib64/$(TARGET).so.0.0 /usr/lib64/$(TARGET).so
	sudo cp FpgaRegisterAccess.h GenesysRegisterAccess.h DukeRegisterAccess.h VeloceRegisterAccess.h /usr/include/fpga_access/
	sudo /sbin/ldconfig -l /usr/lib64/$(TARGET_SO)


sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
