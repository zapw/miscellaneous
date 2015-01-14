# Set destination directory for installing to root by default
DESTDIR?=/# SVOS

# Determine which OS and version is running
OS_NAME := $(shell cat /etc/os-release | grep -w NAME | cut -d '=' -f2)
OS_VERSION := $(shell cat /etc/os-release | grep -w VERSION_ID | cut -d '=' -f2)
OS_PLATFORM := $(shell uname -m)

ifneq ($(OS_NAME), "Intel SVOS")
ifneq ($(OS_NAME), "Debian GNU/Linux")
SUDO := sudo
endif
endif

.PHONY: default all libso iwarpso stat clean install src_clean iwarp_clean src_install iwarp_install
default: all

all: 
	$(MAKE) -C src lib stat
	$(MAKE) -C iwarp/src

libso:
	$(MAKE) -C src lib

iwarpso:
	$(MAKE) -C iwarp/src

stat:
	$(MAKE) -C src stat
			
clean: src_clean iwarp_clean

src_clean:
	$(MAKE) -C src clean

iwarp_clean:
	$(MAKE) -C iwarp/src clean

# If no DESTDIR is set, assume installation is done into root
install: src_install iwarp_install
	$(SUDO) install -d $(DESTDIR)/etc/ld.so.conf.d
	$(SUDO) install cse-drv-x86_64.conf $(DESTDIR)/etc/ld.so.conf.d

src_install:
	$(MAKE) -C src install

iwarp_install:
	$(MAKE) -C iwarp/src install

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
