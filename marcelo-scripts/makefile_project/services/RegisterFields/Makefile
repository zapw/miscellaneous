NAME := RegisterFields

TARGET_SO=lib$(NAME).so
TARGET_ST=lib$(NAME).a
TCL_TARGET_SO=lib$(NAME)Tcl.so

include ../misc.mk

ifeq ($(shell uname -m), x86_64)
        LIBS_DIR := /usr/lib64
else
        LIBS_DIR := /usr/lib
endif


ifeq ($(SVOS),1)
        DESTDIR ?= /
        INSTALL := install
        CREATE_DIR_FLAG := -d
        COPY_HEADER_FLAGS := -m 0444
        LD_CONFIG := /sbin/ldconfig
        LDCONFIG_INSTALL = $(LD_CONFIG) -l
else
        DESTDIR ?=
        INSTALL := sudo
        CREATE_DIR_FLAG := mkdir -p
        COPY_COMMAND := cp
        LD_CONFIG := /sbin/ldconfig
        LDCONFIG_INSTALL = $(INSTALL) $(LD_CONFIG) -l
endif

clean_dirs := src_clean Tests_clean

.PHONY: default all src Tests remove_files clean_lib clean config_files install_commands clean_config_files clean_libfiles
default: all

all: src Tests
NO_TESTS: src

src:
	@printf "\n%s\n" "********************* build sources **************************"
	$(MAKE) -C $@

Tests: src
	@printf "\n%s\n" "********************* build tests **************************"
	$(MAKE) -C $@

install: config_files install_commands

config_files:
	$(MAKE) -C ../ConfigFiles/$(NAME)

install_commands:
	$(INSTALL) $(CREATE_DIR_FLAG) $(DESTDIR)$(LIBS_DIR)/$(NAME)/
	$(INSTALL) $(COPY_COMMAND) $(TARGET_SO) $(DESTDIR)$(LIBS_DIR)/$(TARGET_SO)
	$(INSTALL) $(COPY_COMMAND) $(TARGET_ST) $(DESTDIR)$(LIBS_DIR)/$(TARGET_ST)
	$(INSTALL) $(COPY_COMMAND) $(TCL_TARGET_SO) $(DESTDIR)$(LIBS_DIR)/$(TCL_TARGET_SO)
ifndef SVOS
	$(LDCONFIG_INSTALL) $(DESTDIR)$(LIBS_DIR)/$(TARGET_SO)
	$(LDCONFIG_INSTALL) $(DESTDIR)$(LIBS_DIR)/$(TCL_TARGET_SO)
endif
	$(INSTALL) $(COPY_COMMAND) $(CURDIR)/TCL/$(NAME).tcl $(DESTDIR)$(LIBS_DIR)/$(NAME)/$(NAME).tcl
	$(INSTALL) $(COPY_COMMAND) $(CURDIR)/TCL/pkgIndex.tcl $(DESTDIR)$(LIBS_DIR)/$(NAME)/pkgIndex.tcl
	$(INSTALL) $(CREATE_DIR_FLAG) $(DESTDIR)/usr/include/services/$(NAME)/
	$(INSTALL) $(COPY_COMMAND) $(COPY_HEADER_FLAGS) inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/

clean: remove_files $(clean_dirs)

remove_files:
	rm -rf TCL/*.cxx
	rm -rf ./*.so.* ./*.so ./*.a.* ./*.a

$(clean_dirs):
	$(MAKE) -C $(@:%_clean=%) clean
	
clean_lib: clean_config_files clean_libfiles

clean_libfiles:
	$(INSTALL) rm -rf /usr/include/services/$(NAME)
	$(INSTALL) rm -rf $(LIBS_DIR)/*lib$(NAME)*
ifneq ($(strip $(NAME)),)
	$(INSTALL) rm -rf $(LIBS_DIR)/$(NAME)
endif
clean_config_files:
	$(MAKE) -C ../ConfigFiles/$(NAME) clean_lib
