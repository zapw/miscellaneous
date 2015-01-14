CC=gcc
ODIR=obj
SDIR=src
SRCS=$(wildcard $(SDIR)/*.c) 
OBJS=$(patsubst $(SDIR)/%.c, $(ODIR)/%.o, $(SRCS))
CURDIR:=$(shell pwd)
LIBDIR=lib
CFLAGS=-Wall -g -Wextra -fPIC
LIBS=-ldl -lpthread -lftd2xx
SRD=libduke.so
MAJOR=0
MINOR=0
VERSION=$(MAJOR).$(MINOR)
TARGET_V=$(SRD).$(VERSION)
TARGET=$(LIBDIR)/$(TARGET_V)
INC_DIR=inc
INC=-I$(INC_DIR)
MAKE_APPDATA_DIR=./script/create_appdata_dir.py
DUKE_GOBAL_INC_DIR=/usr/include/dukeproxy/
GLOBAL_LIB_DIR=/usr/lib64/
DUKE_PROFILE_DIR=/etc/profile.d
DUKE_ENV=$(DUKE_PROFILE_DIR)/dukeproxyenv.sh
DUKE_WORK_DIR=/usr/local/var/duke/
DUKE_CONFIG=dukeproxy.cfg
LOG_CFG=logger.cfg
LOCK_FILE=.lock
LOGGER_CFG_PROTO=cfg/logger.cfg.proto 
LOCAL_DUKE_CONFIG=$(LOCAL_APP_DATA)/$(DUKE_CONFIG)
LOCAL_LOG_CFG=$(LOCAL_APP_DATA)/$(LOG_CFG)
GLOBAL_DUKE_CONFIG=$(DUKE_WORK_DIR)$(DUKE_CONFIG)
GLOBAL_LOG_CFG=$(DUKE_WORK_DIR)$(LOG_CFG)
GLOBAL_LOCK_FILE=$(DUKE_WORK_DIR)$(LOCK_FILE)

.PHONY: test all clean

all: $(TARGET)

$(LIBDIR) $(ODIR):
	-mkdir -p $@

$(TARGET): $(OBJS)
	$(CC) $(INC) -lz -shared -o $(TARGET) $(OBJS) $(LIBS) -lc
	ln -sf $(TARGET_V) $(LIBDIR)/$(SRD)

$(OBJS): | $(LIBDIR) $(ODIR)

$(ODIR)/%.o: $(SDIR)/%.c
	$(CC) $(INC) $(CFLAGS) -c $< -o $@

test: test/dukemgrtest.c
	$(CC) $(INC) $(CFLAGS) -Wl,-rpath,lib -Llib -lduke $< -o mgrtest

install:
	mkdir -p $(DESTDIR)$(GLOBAL_LIB_DIR)
	mkdir -p $(DESTDIR)$(DUKE_GOBAL_INC_DIR)
	mkdir -p $(DESTDIR)$(DUKE_PROFILE_DIR)
	cp $(TARGET) $(DESTDIR)$(GLOBAL_LIB_DIR)
	ln -fs $(GLOBAL_LIB_DIR)/$(TARGET_V) $(DESTDIR)$(GLOBAL_LIB_DIR)/$(SRD)
	cp $(INC_DIR)/dukeproxy.h $(INC_DIR)/duketype.h $(DESTDIR)$(DUKE_GOBAL_INC_DIR)
	@echo "export DUKE_PROXY_CONFIG_DIR=$(DUKE_WORK_DIR)" >  $(DESTDIR)$(DUKE_ENV)
	$(MAKE_APPDATA_DIR) -d $(DUKE_WORK_DIR) -l $(LOGGER_CFG_PROTO) -p $(DESTDIR) -P global

uninstall:
	rm -f  $(GLOBAL_LIB_DIR)/$(TARGET_V) $(GLOBAL_LIB_DIR)/$(SRD)
	rm -rf $(DUKE_GOBAL_INC_DIR) $(DUKE_WORK_DIR)                                                   
clean:
	rm -fr $(LIBDIR) $(ODIR)


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
