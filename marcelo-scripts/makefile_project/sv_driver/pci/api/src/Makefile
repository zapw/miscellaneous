.DELETE_ON_ERROR:
# If no DESTDIR is set, assume installation is done into root
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

CC = g++ -pthread
LIB_OBJS = 	PciApiWrapper.o\
		PciPort.o\
		PciPortLocal.o\
		PciPortRemote.o\
		PciTable.o\
        PciComponent.o\
        PciComponentsFactory.o\

LIBS = -ldl

INC = -I../inc -I../../../api/inc -I../../../remoting/Rcf/include -I../../../remoting/server -I/usr/include/sv_driver/api
DBG = -g
CFLAGS = -fPIC -Wall
CFLAGS += -D__PTHREAD

TARGET_SO=libPciApi.so


ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif


%.o: %.cpp
	$(CC) $(INC) $(CFLAGS) $(DBG) -c $<

.PHONY: default all install clean
default: all
all: $(TARGET_SO)

vpath Rcf ../../../remoting

$(TARGET_SO): $(LIB_OBJS)
	$(CC) $(INC) -lpci -lz -shared -Wl,-soname,$(TARGET_SO) -o $(TARGET_SO) $(LIB_OBJS) -lc
	
Rcf:
	$(MAKE) -C ../../../remoting Rcf

install:
	@echo $(LIBS_DIR)
	$(SUDO) install $(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
ifndef SVOS
	$(SUDO) /sbin/ldconfig -l $(DESTDIR)/$(LIBS_DIR)/$(TARGET_SO)
endif
	$(SUDO) install -d $(DESTDIR)/usr/include/sv_driver/pci
	$(SUDO) install ../inc/*.h $(DESTDIR)/usr/include/sv_driver/pci

clean:
	rm -f *.so *.o $(includes)

sources = $(wildcard *.cpp)

#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F)) | Rcf
	$(CC) $(INC) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
