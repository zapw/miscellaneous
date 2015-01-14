
.DELETE_ON_ERROR:
# Set destination directory for installing to root by default
DESTDIR?=/#SVOS

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
USE_SERVICES = 0
LIB_OBJS = 	CHmcDebug.o CCpkHmcParser.o CFpkHmcParser.o CFvlHmcParser.o CGenericHmcParser.o CHmcParserFactory.o CFpkQpContextObject.o CFpkCqContextObject.o CFpkArpTable.o CFpkIrrqObject.o CFpkMrte.o CFpkXmitFifo.o CCpkQpContextObject.o CCpkCqContextObject.o CCpkArpTable.o CCpkIrrqObject.o CCpkMrte.o CCpkXmitFifo.o

HFILES = 	CHmcDebug.h CCpkHmcParser.h CFpkHmcParser.h CFvlHmcParser.h CGenericHmcParser.h CHmcParserFactory.h CGenericHmcObject.h CFpkQpContextObject.h CFpkCqContextObject.h CFpkArpTable.h CFpkIrrqObject.h CFpkMrte.h CFpkXmitFifo.h CCpkQpContextObject.h CCpkCqContextObject.h CCpkArpTable.h CCpkIrrqObject.h CCpkMrte.h CCpkXmitFifo.h 
LIBS = -ldl -lpthread -lboost_system
LIBS_STAT = -L. -ldrva
INC =	-I../inc \
	-I../../../../api/inc \
	-I../../../../api/iwarp/inc \
	-I../../../../sv_shared/ \
	-I../../../../nes/shared \
	-I../../../../i40e/shared \
	-I../../../../i200e/shared \

DBG = -g
CFLAGS = -fPIC -Wall -DRCF_USE_BOOST_ASIO -Wno-deprecated
CFLAGS += -D__PTHREAD
CFLAGS += -DDRIVER_API
CFLAGS += -DIWNES
CFLAGS += -DI40IW
CFLAGS += -DDRIVER_API
CFLAGS += -DDRIVER_API_CHECK_VERSION

ifeq ($(USE_SERVICES),1)
CFLAGS += -DUSE_SERVICES
endif

TARGET_SO=libHmcDebug.so.0.0



ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else 
ifeq ($(shell uname -m), ppc64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif
endif


%.o: %.cpp
	$(CC) $(INC) $(CFLAGS) $(DBG) -c $<

.PHONY: all

all: lib stat 
	
lib: libHmcDebug.so

libHmcDebug.so: $(LIB_OBJS)

ifeq ($(USE_SERVICES),1)  #closed by default
	$(CC) $(RCF_OBJ) $(INC) -lOnRingElements -lpcap -lpci -lz -shared -Wl,-soname,libHmcDebug.so -o ../lib/$(TARGET_SO) $(LIB_OBJS) -lc
	/sbin/ldconfig -n ../lib
else
	$(CC) $(RCF_OBJ) $(INC) -lpcap -lpci -lz -shared -Wl,-soname,libHmcDebug.so -o ../lib/$(TARGET_SO) $(LIB_OBJS) -lc
	/sbin/ldconfig -n ../lib
endif

install:
	@echo $(CURDIR)
	@echo $(LIBS_DIR)
	#export LD_RUN_PATH=/home/rchen7-l/nevada/sv_driver/api/lib
	$(SUDO) install -d $(DESTDIR)$(LIBS_DIR)
	$(SUDO) install  ../lib/libHmcDebug.a $(DESTDIR)$(LIBS_DIR)
	$(SUDO) install  ../lib/$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
ifndef SVOS
	$(SUDO) /sbin/ldconfig -l $(DESTDIR)/$(LIBS_DIR)/$(TARGET_SO)
endif
	$(SUDO) install -d $(DESTDIR)/usr/include/sv_driver/tools/HmcDebug/
	$(SUDO) install -m 0444 ../inc/*.h $(DESTDIR)/usr/include/sv_driver/tools/HmcDebug/

	#export LD_RUN_PATH
	#@echo $$LD_RUN_PATH

stat: libHmcDebug.a

libHmcDebug.a: $(LIB_OBJS)
	mkdir -p ../lib
	ar -rcs ../lib/libHmcDebug.a $(LIB_OBJS) $(RCF_OBJ)

clean:
	rm -f ../lib/*.so* ../lib/*.a *.o $(includes)
	$(SUDO) rm -rf $(DESTDIR)/usr/include/sv_driver/tools/HmcDebug/

sources = $(wildcard *.cpp)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile) called .name.cpp.d from a C++ source file called name.cpp:

#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(INC) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
