################################################################################
#
# 
# Copyright(c) 1999 - 2010 Intel Corporation. All rights reserved.
# 
# Rafi Chen 17.1.2017
# Makefile for building i200evf sv driver
#
################################################################################
#ARCH := $(shell uname -m | sed 's/i.86/i386/')
.PHONY: clean install default print

KDIR	?= /lib/modules/$(shell uname -r)/build
#MODULES_DIR	?= /lib/modules/$(shell uname -r)
RDMA	?= 0
$(warning Using Kernel directory: $(KDIR))

KERNEL_VERSION:=$(shell uname -r | cut -c1-6)

default: | sv_shared shared lan
	cp --preserv ../sv_shared/*.h ../sv_shared/*.c sv_shared
	cp --preserv ../i200e/shared/*.c shared
	cp --preserv ../i200e/lan/*.c lan
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules
	rm -f ./sv_shared/*.h ./sv_shared/*.c ./lan/*.c ./shared/*.c

sv_shared:
	-mkdir sv_shared

shared:
	-mkdir shared

lan:
	-mkdir lan

install:
	sudo $(MAKE) -C $(KDIR) M=$(CURDIR) INSTALL_MOD_DIR=kernel/drivers/net/ethernet/intel/i200evf modules_install

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean
	rm -rf sv_shared *.o.cmd *.o shared/.*.o.cmd shared/.*.o lan/.*.o.cmd lan/.*.o iwarp/.*.o.cmd iwarp/*.o iw_shared

print:
	@$(MAKE) -f ./Kbuild print

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
