.DELETE_ON_ERROR:
CC = g++ -pthread -std=c++11
LIB_OBJS :=	CpmDeviceManager.o\
		CpmBaseFunction.o\
		CpmDevice.o\
		CpmPF.o\
		CpmPFLocal.o\
		CpmMemBlock.o\
		CpmCsrBlock.o\
		CpmUEngine.o \
		Cpm_ueng_cluster.o \
		Cpm_ueng.o \
		CpmSriov.o
			

LIBS = -ldl -lpthread -lboost_system
LIBS_STAT = -L. -ldrva
INC = 	-I../inc -I../../../api/inc

DBG = -g
CFLAGS = -fPIC -Wall -DRCF_USE_BOOST_ASIO -Wno-deprecated
CFLAGS += -D__PTHREAD
CFLAGS += -DCPM_DRIVER

TARGET_SO=libCpmDriverApi.so.0.0


RCF_OBJ=../../../remoting/Rcf/RCF.o

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

.PHONY: default all lib stat
default: all

all: lib stat

lib: libCpmDriverApi.so

libCpmDriverApi.so: $(LIB_OBJS)
	$(CC) $(INC) -lz -shared -Wl,-soname,libCpmDriverApi.so -o ../lib/$(TARGET_SO) $(LIB_OBJS) -lc
	#cp $(TARGET_SO) ../lib
	#/sbin/ldconfig -n ../lib
	

install:
	@echo $(LIBS_DIR)
	sudo cp ../lib/$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
	sudo rm -rf /usr/include/cpm_driver
	sudo mkdir -p /usr/include/cpm_driver/api
	sudo cp ../inc/*.h /usr/include/cpm_driver/api	


#stat: rcf libDriverIwarpApi.a
stat: libCpmDriverApi.a

libCpmDriverApi.a: $(LIB_OBJS)
	ar -rcs ../lib/libCpmDriverApi.a $(LIB_OBJS) 

rcf:
	$(MAKE) -C ../../remoting RCF


LIBS_CPP = $(LIB_OBJS:%.o=%.cpp)

#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(LIBS_CPP),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(INC) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif

#setuid:
#	chmod u+s ./testapi

clean:
	rm -f ../lib/*.so* ../lib/*.a *.o $(includes)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
