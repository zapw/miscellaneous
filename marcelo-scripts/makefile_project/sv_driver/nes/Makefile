################################################################################
# 
# Copyright(c) 1999 - 2010 Intel Corporation. All rights reserved.
# 
# Makefile for building ne020 iwarp dv driver
#

#
################################################################################
#ARCH := $(shell uname -m | sed 's/i.86/i386/')


KDIR	:= /lib/modules/$(shell uname -r)/build

default:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean
	rm -rf sv_shared *.o.cmd shared/.*.o.cmd ../iw_shared/*.o ../sv_shared/*.o

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
