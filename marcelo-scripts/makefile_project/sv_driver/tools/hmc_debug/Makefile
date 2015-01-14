###############################################################
#											                                                                   #
#  Makefile for Hmc Debug Tool - all directories								   #
#                                                           												  #
###############################################################

.PHONY: lib all hmcDebugCli hmcDebugGui hmc_debug_cli hmc_debug_lib hmc_debug_gui install clean

all: hmcDebugCli hmcDebugGui

lib = hmc_debug_lib/lib/libHmcDebug.so

vpath %.so ../../api/lib ../../pci/api/src ../../jtagAccess/src

hmcDebugCli: $(lib) libDriverIwarpApi.so libDriverApi.so libPciApi.so libJtagAccess.so
	$(MAKE) -C hmc_debug_cli

hmcDebugGui: $(lib) libDriverIwarpApi.so libDriverApi.so libPciApi.so libJtagAccess.so
	$(MAKE) -C hmc_debug_gui

libDriverIwarpApi.so:
	$(MAKE) -C ../../api/iwarp lib

libDriverApi.so:
	$(MAKE) -C ../../api/src lib

libPciApi.so:
	$(MAKE) -C ../../pci/api/src

libJtagAccess.so:
	$(MAKE) -C ../../jtagAccess/src

$(lib):
	$(MAKE) -C hmc_debug_lib/src
	

subdirs = hmc_debug_cli hmc_debug_lib hmc_debug_gui
install clean: $(subdirs)

$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
