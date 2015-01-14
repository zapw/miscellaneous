NAME := Utilities
TARGET_SO := lib$(NAME).so

DIRS := src
CLEANDIRS := $(DIRS:%=clean-%)

ifdef SVOS
DESTDIR ?= /
        INSTALL := install
	CREATE_DIR_FLAG := -d
	COPY_HEADER_FLAGS := -m 0444
	LDCONFIG_INSTALL = /sbin/ldconfig -l
	REMOVE_RECURSIVE_FORCED := rm -rf
else
	INSTALL := sudo
	CREATE_DIR_FLAG := mkdir -p
	COPY_COMMMAND := cp
	LDCONFIG_INSTALL = $(INSTALL) /sbin/ldconfig -l
	REMOVE_RECURSIVE_FORCED := $(INSTALL) rm -rf
endif


ifeq ($(shell uname -m), x86_64)
        LIBS_DIR := /usr/lib64
else
        LIBS_DIR := /usr/lib
endif


.PHONY: default all NO_TESTS clean clib install clean_lib tests $(DIRS) $(CLEANDIRS) clean_parallel

default: all

all: $(DIRS) tests

ifdef MAKECMDGOALS
  ifneq ($(filter-out clean clean_lib,$(MAKECMDGOALS)),)
   tests: $(DIRS)
  endif
else
 tests: $(DIRS)
endif

tests:
	$(MAKE) -C tests $(filter-out clean_lib,$(MAKECMDGOALS))

$(DIRS):
	@printf "\n%s\n" "*******************compiling $(CURDIR)/$(@)*******************"
	$(MAKE) -C $@

NO_TESTS: $(DIRS)

clib: $(DIRS)

clean: $(CLEANDIRS) clean_parallel tests

clean_parallel:
	rm -f *.so *.so.* *.a

install: 
	$(INSTALL) $(CREATE_DIR_FLAG) $(DESTDIR)/usr/include/services/$(NAME)/
	$(INSTALL) $(COPY_COMMMAND) $(COPY_HEADER_FLAGS) inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/
	$(INSTALL) $(COPY_COMMMAND) ./PowerKvmControlScript.sh $(DESTDIR)/usr/include/services/$(NAME)/
	$(INSTALL) $(COPY_COMMMAND) $(TARGET_SO) $(DESTDIR)$(LIBS_DIR)/$(TARGET_SO)
	$(LDCONFIG_INSTALL) $(DESTDIR)$(LIBS_DIR)/$(TARGET_SO)

clean_lib: 
	$(REMOVE_RECURSIVE_FORCED) /usr/include/services/$(NAME) $(LIBS_DIR)/*lib$(NAME)*


$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean

include ../misc.mk
