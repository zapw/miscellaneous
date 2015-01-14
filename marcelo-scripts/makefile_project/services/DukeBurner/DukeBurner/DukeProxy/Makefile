TARGET_SO := libDukeProxyJNI.so

targets_so := $(TARGET_SO)
targets_so_preq := -lftd2xx

ifeq ($(strip $(JAVA_HOME)),)
 JAVA_HOME := $(shell readlink -f $$(type javac|cut -d' ' -f3) | sed "s:bin/javac:include:")
endif
all_lib_inc := -I$(JAVA_HOME) -I$(JAVA_HOME)/linux
include ../../../preq.mk

GLOBAL_LIB_DIR := /usr/lib64
VERSION := 0.0.0
TARGET_DIR := target
CFLAGS := -Wall -g -Wextra -fPIC

OBJS := $(patsubst %.c,%.o,$(wildcard *.c))
LIBS := -lc -ldl -lpthread

.PHONY:  all install uninstall clean

all: $(TARGET_SO)
	cp $(TARGET_SO) $(TARGET_DIR)

$(TARGET_SO):  $(OBJS) | $(TARGET_DIR)
	$(CC) -lz -shared -Wl,-soname,$(TARGET_SO) -o $(TARGET_SO) $(OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	
$(TARGET_DIR):
	-mkdir -p $(TARGET_DIR)

install:
	mkdir -p $(DESTDIR)$(GLOBAL_LIB_DIR)
	cp       $(TARGET_SO) $(DESTDIR)$(GLOBAL_LIB_DIR)/$(TARGET_SO).$(VERSION)
	ln -fsr  $(DESTDIR)$(GLOBAL_LIB_DIR)/$(TARGET_SO).$(VERSION) $(DESTDIR)$(GLOBAL_LIB_DIR)/$(TARGET_SO)

uninstall:
	rm -f $(GLOBAL_LIB_DIR)/$(TARGET_SO).*


clean:
	rm -rf $(TARGET_SO) $(includes) $(TARGET_DIR) $(OBJS)

sources := $(OBJS:.o=.c)

$(eval $(auto_prerequisite_gen))
