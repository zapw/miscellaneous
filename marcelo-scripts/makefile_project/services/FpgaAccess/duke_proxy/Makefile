OBJECTS=duke_proxy.o
LIBS = -ldl -lpthread -lc -lz
TARGET = libDukeProxy
TARGET_SO=$(TARGET).so.0.0

targets_so := $(TARGET).so
targets_so_preq := -lftd2xx

include ../../preq.mk
CFLAGS=-Wall -g -Wextra -fPIC

.PHONY: all install clean
all: $(TARGET).so

$(TARGET).so: $(OBJECTS)
	 $(CXX) -shared -Wl,-soname,$(TARGET).so -o $(TARGET_SO) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	 ln -fs $(TARGET).so.0.0 $(TARGET).so
clean:
	rm -f $(TARGET_SO) *.o $(includes) $(TARGET).so $(OBJECTS)

install:
	sudo cp $(TARGET_SO) /usr/lib64/
	sudo ln -fs /usr/lib64/$(TARGET).so.0.0 /usr/lib64/$(TARGET).so
	sudo mkdir -p /usr/include/fpga_access/
	sudo cp duke_proxy.h /usr/include/fpga_access/
#	sudo cp ftd2xx.h WinTypes.h /usr/include/duke_burner/
	sudo /sbin/ldconfig -l /usr/lib64/$(TARGET_SO)

sources := $(OBJECTS:%.o=%.c)

$(eval $(auto_prerequisite_gen))
