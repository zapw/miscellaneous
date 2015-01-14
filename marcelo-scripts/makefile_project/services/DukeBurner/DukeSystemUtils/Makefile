DUKEMAINDIR=/opt/dukeutils/
TARGET_DIR=target
DUKE_PROXY_DIR=duke-proxy
DUKE_PY_DIR=dukepyctl
DUKE_J_DIR=dukejctl
DUKE_PROXY_DIR=duke-proxy
DUKE_PROXY_DIR_C=$(DUKE_PROXY_DIR)/duke-proxy
MAKE_APPDATA_DIR=$(DUKE_PROXY_DIR_C)/script/create_appdata_dir.py
LOCAL_APP_DATA_DIR=appdata
LOGGER_CFG_PROTO=$(DUKE_PROXY_DIR_C)/cfg/logger.cfg.proto 

targets_dirs =  $(DUKE_PROXY_DIR) $(DUKE_J_DIR) $(DUKE_PY_DIR)
targets_clean := $(targets_dirs:%=%_clean)
targets_install := $(targets_dirs:%=%_install)
targets_uninstall := $(targets_dirs:%=%_uninstall)

.PHONY: createdir $(targets_dirs) $(targets_clean) $(targets_install) $(targets_uninstall)

default: $(targets_dirs)

$(targets_dirs): | $(TARGET_DIR) createdir
	$(MAKE) -C $@
	cp $@/target/* $(TARGET_DIR)

$(DUKE_J_DIR) : $(DUKE_PROXY_DIR)

createdir: $(TARGET_DIR)
	$(MAKE_APPDATA_DIR) -d $(LOCAL_APP_DATA_DIR) -l $(LOGGER_CFG_PROTO) -C $(TARGET_DIR)

$(TARGET_DIR):
	-mkdir -p $(TARGET_DIR)

clean: $(targets_clean)
	rm -rf $(TARGET_DIR)

$(targets_clean):
	$(MAKE) -C $(@:%_clean=%) clean

install: $(targets_install) | $(DESTDIR)/$(DUKEMAINDIR)

$(DESTDIR)/$(DUKEMAINDIR):
	-mkdir -p $(DESTDIR)/$(DUKEMAINDIR)

$(targets_install):
	$(MAKE) -C $(@:%_install=%) DUKEMAINDIR=$(DUKEMAINDIR) DESTDIR=$(DESTDIR) install

uninstall: $(targets_uninstall)
	rm -rf $(DUKEMAINDIR)

$(targets_uninstall):
	$(MAKE) -C $(@:%_uninstall=%) DUKEMAINDIR=$(DUKEMAINDIR) uninstall

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;

