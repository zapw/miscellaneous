################################################################################
#
# 
# Copyright(c) 1999 - 2010 Intel Corporation. All rights reserved.
# 
# Makefile for building i200e sv driver
#
################################################################################
#ARCH := $(shell uname -m | sed 's/i.86/i386/')

KDIR	?= /lib/modules/$(shell uname -r)/build
$(warning Using Kernel directory: $(KDIR))

.PHONY: default print
KERNEL_VERSION:=$(shell uname -r | cut -c1-6)

# note that older kernels (e.g. 2.6.16) are not supported
default: | sv_shared iw_shared
	cp --preserv ../sv_shared/*.h ../sv_shared/*.c sv_shared
	cp --preserv ../iw_shared/*.h ../iw_shared/*.c iw_shared
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules
	rm -f ./sv_shared/*.h ./sv_shared/*.c ./iw_shared/*.h ./iw_shared/*.c

sv_shared:
	-mkdir sv_shared
iw_shared:
	-mkdir iw_shared
clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean
	rm -rf sv_shared *.o.cmd  *.o shared/.*.o.cmd shared/.*.o lan/.*.o.cmd lan/.*.o iwarp/.*.o.cmd iwarp/*.o iw_shared

print:
	$(MAKE) -f ./Kbuild print

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
