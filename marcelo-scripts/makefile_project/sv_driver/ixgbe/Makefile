KDIR    ?= /lib/modules/$(shell uname -r)/build
$(warning Using Kernel directory: $(KDIR))

KERNEL_VERSION:=$(shell uname -r | cut -c1-6)

ifeq ($(KERNEL_VERSION), 2.6.16)
	     
default: | sv_shared
	@echo kernel version = $(KERNEL_VERSION)
	cp shared/*.h .
	cp ../sv_shared/*.h .
	cp ../api/inc/DriverApi.h ../api/inc/DriverApiTypes.h ../api/inc/TeraramApi.h .
        
	cp --preserv ../sv_shared/*.h ../sv_shared/*.c sv_shared
	
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules
	rm -f sv_*.h
	rm -f kcompat.h
	rm -f DriverApi.h
	rm -f TeraramApi.h
else

default: | sv_shared
	cp --preserv ../sv_shared/*.h ../sv_shared/*.c sv_shared
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules
	rm -f ./sv_shared/*.h ./sv_shared/*.c
endif

sv_shared: 
	-mkdir sv_shared

install:
	sudo cp ../config/40-sv-ctrl.rules /etc/udev/rules.d
	../load.sh ixgbe
	
clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean
	rm -rf sv_shared
	rm -f *.o.cmd
	rm -f shared/.*.o.cmd
	

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
