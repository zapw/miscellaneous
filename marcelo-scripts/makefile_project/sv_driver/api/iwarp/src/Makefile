.DELETE_ON_ERROR:
# If no DESTDIR is set, assume installation is done into root
DESTDIR?=/# SVOS

OS := $(shell awk -F= '/^(NAME|VERSION_ID)=/ { print  $$2}' /etc/os-release 2>/dev/null)
OS_NAME := $(word 1, $(OS))
OS_VERSION := $(word 2, $(OS))
OS_PLATFORM := $(shell uname -m)


ifneq ($(OS_NAME), "Intel SVOS")
ifneq ($(OS_NAME), "Debian GNU/Linux")
SUDO := sudo
endif
endif

LIB_OBJS := ne020_iwarp_u_k.o \
		 uda_uk.o uk.o \
		i40iw_uda_uk.o \
		i40iw_uk.o \
		IwarpDriverAccess.o \
		IwarpNesPD.o \
		IwarpI40iwPD.o \
		IwarpNesCQ.o \
		IwarpI40iwCQ.o \
		IwarpQP.o \
		I40iwQP.o \
		RoCeI40iwQP.o \
		IwarpNesQP.o \
		IwarpI40iwQP.o \
		IwarpCQP.o \
		IwarpAEQ.o \
		IwarpCEQ.o \
		IwarpCM.o \
		IwarpStag.o \
		IwarpMR.o \
		IwarpSharedMR.o \
		IwarpMW.o \
		IwarpI40iwMR.o \
		IwarpNesMR.o \
		IwarpNesSharedMR.o \
		IwarpI40iwSharedMR.o \
		IwarpI40iwMW.o \
		IwarpNesMW.o \
		IwarpResMgr.o \
		IwarpNesResMgr.o \
		IwarpI40eResMgr.o \
		IwarpIceResMgr.o \
		IwarpEventPipe.o \
		IwarpDriverConfig.o \
		IwarpI40iwUDAQP.o\
		IwarpExceptionQ.o\
		IwarpInHostPbl.o\
		IceQP.o\
		IwarpIceCQ.o\
		IwarpIceMR.o\
		IwarpIceMW.o\
		IwarpIcePD.o\
		IwarpIceQP.o\
		RoceIceQP.o\
        RoceUdIceQP.o\
		IwarpIceSharedMR.o\
		CIceUDAQP.o \
        RdmaStagZero.o \
        IwarpPD.o

LIBS := -ldl -lpthread -lboost_system
LIBS_STAT := -L. -ldrva
INC := -I./inc \
	-I../inc \
	-I../../../api/inc \
	-I../../../nes/shared\
	-I../../../i40e/shared\
	-I../../../i200e/shared\
	-I../../../remoting/Rcf/include\
	-I../../../remoting/server\

DBG := -g
FLAGS :=  -pthread
FLAGS += -fPIC -Wall -DRCF_USE_BOOST_ASIO -Wno-deprecated
FLAGS += -D__PTHREAD
FLAGS += -DDRIVER_API
FLAGS += -DUDA_ENABLED
FLAGS += -DMKI_ROCE
FLAGS += -DCHECK_PARAMS
FLAGS += -DRDMA_VIRTCHNL
FLAGS += -DAH_UDA
FLAGS += -DSV_DRIVER

CXXFLAGS := $(FLAGS) $(INC) $(DBG)
CC := g++
CFLAGS := $(CXXFLAGS)

TARGET_SO := libDriverIwarpApi.so.0.0

vpath %.c ../../../i40e/shared ../../../nes/shared ../../../i200e/shared

RCF_OBJ := ../../../remoting/Rcf/RCF.o

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
ifeq ($(shell uname -m), ppc64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif
endif

.PHONY: default all lib stat

default: all

all:  lib stat

lib: ../lib/libDriverIwarpApi.so ../../lib/$(TARGET_SO) ../../lib/libDriverIwarpApi.so
stat: ../lib/libDriverIwarpApi.a
	
../lib/libDriverIwarpApi.a: $(LIB_OBJS) $(RCF_OBJ)
	ar -rcs ../lib/libDriverIwarpApi.a $(LIB_OBJS) $(RCF_OBJ)

../lib/libDriverIwarpApi.so: $(LIB_OBJS) $(RCF_OBJ)
	$(CXX) $(INC) -lz -shared -Wl,-soname,libDriverIwarpApi.so -o ../lib/$(TARGET_SO) $(LIB_OBJS) -lc
	/sbin/ldconfig -n ../lib


../../lib/$(TARGET_SO): ../lib/libDriverIwarpApi.so
	cp ../lib/$(TARGET_SO) ../../lib

../../lib/libDriverIwarpApi.so: ../lib/libDriverIwarpApi.so
	ln -sf $(TARGET_SO) ../../lib/libDriverIwarpApi.so

$(RCF_OBJ):
	$(MAKE) -C ../../../remoting RCF

install:
	@echo $(LIBS_DIR)
	$(SUDO) install -d $(DESTDIR)$(LIBS_DIR)
	$(SUDO) install ../lib/$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
ifndef SVOS
	$(SUDO) /sbin/ldconfig -l $(DESTDIR)/$(LIBS_DIR)/$(TARGET_SO)
endif
	$(SUDO) install -d $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../inc/*.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	
	# neteffect iwarp includes
	$(SUDO) install ../../../nes/shared/iwarp_d.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../nes/shared/i40e_d.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../nes/shared/i40e_ring.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../nes/shared/i40e_type.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../nes/shared/ne020_p.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	# fortville iwarp includes
	$(SUDO) install ../../../i40e/shared/i40iw_user.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_type.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_uda.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_uda_user.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_d.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40e_hmc.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40e_osdep.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40e_status.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_status.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_vf.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_virtchnl.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_hmc.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i40e/shared/i40iw_sv_user_sc_def.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	# cpk iwarp includes
	$(SUDO) install ../../../i200e/shared/user.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/type.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/uda.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/uda_user.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/defs.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/hmc.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/ice_osdep.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/status.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/vf.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/virtchnl.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/hmc.h $(DESTDIR)/usr/include/sv_driver/api/iwarp
	$(SUDO) install ../../../i200e/shared/icrdma_sv_user_sc_def.h $(DESTDIR)/usr/include/sv_driver/api/iwarp

clean:
	rm -f ../lib/*.so* ../lib/*.a *.o *.d ../../lib/$(TARGET_SO) ../../lib/libDriverIwarpApi.so $(includes)

sources := $(LIB_OBJS:.o=.cpp)

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
%.d: $$(call template,$$(@D),$$(*F))
	$(CXX) $(INC) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

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
