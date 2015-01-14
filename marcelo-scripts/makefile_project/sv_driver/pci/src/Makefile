################################################################################
#
#
# Copyright(c) 1999 - 2009 Intel Corporation. All rights reserved.
#
# Makefile for building igb sv driver
#
################################################################################
#ARCH := $(shell uname -m | sed 's/i.86/i386/')

# If no DESTDIR is set, assume installation is done into root
DESTDIR?=/# SVOS
KDIR	?= /lib/modules/$(shell uname -r)/build
$(warning Using Kernel directory: $(KDIR))

# Determine which OS and version is running
OS_NAME := $(shell cat /etc/os-release | grep -w NAME | cut -d '=' -f2)
OS_VERSION := $(shell cat /etc/os-release | grep -w VERSION_ID | cut -d '=' -f2)
OS_PLATFORM := $(shell uname -m)

ifneq ($(OS_NAME), "Intel SVOS")
ifneq ($(OS_NAME), "Debian GNU/Linux")
SUDO := sudo
endif
endif

KERNEL_VERSION:=$(shell uname -r | cut -c1-6)

ifeq ($(KERNEL_VERSION), 2.6.16)
	     
default:
	@echo kernel version = $(KERNEL_VERSION)
	cp ../inc/*.h .
	cp ../api/inc/PciApi.h .
	cp ../../api/inc/DriverApi.h .
	cp ../../api/inc/DriverApiTypes.h .
	cp ../../api/inc/TeraramApi.h .
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules
	rm -f *_*.h kcompat.h *Api*.h
else

default:
	echo $(CURDIR)
	$(MAKE) -C $(KDIR) M=$(CURDIR)  modules

endif
install:
	$(SUDO) install -d $(DESTDIR)$/etc/udev
	$(SUDO) install ../config/40-pci-ctrl.rules $(DESTDIR)/etc/udev/rules.d/
clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
