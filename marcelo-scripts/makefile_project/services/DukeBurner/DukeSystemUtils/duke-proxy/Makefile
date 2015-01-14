DUKE_PROXY=duke-proxy
DUKE_PROXYJ=duke-proxyj
DUKE_PROXYPY=duke-proxypy
TARGET_DIR=target

targets_dirs =  $(DUKE_PROXY) $(DUKE_PROXYJ) $(DUKE_PROXYPY)
targets_clean := $(targets_dirs:%=%_clean)
targets_install := $(targets_dirs:%=%_install)
targets_uninstall := $(targets_dirs:%=%_uninstall)


.PHONY: $(targets_dirs) $(targets_clean)  $(targets_install) $(targets_uninstall) default 
default: $(DUKE_PROXY) $(DUKE_PROXYJ) $(DUKE_PROXYPY) | $(TARGET_DIR)
	cp $(DUKE_PROXY)/lib/* $(TARGET_DIR)
	cp $(DUKE_PROXYJ)/target/* $(TARGET_DIR)
	cp $(DUKE_PROXYPY)/target/* $(TARGET_DIR)

$(DUKE_PROXYJ) $(DUKE_PROXYPY): $(DUKE_PROXY)
	$(MAKE) -C $@

$(DUKE_PROXY):
	$(MAKE) -C $(DUKE_PROXY)

$(TARGET_DIR):
	-mkdir -p $@

$(targets_clean):
	$(MAKE) -C $(@:%_clean=%) clean

clean: $(targets_clean)
	rm -rf $(TARGET_DIR)

install: $(targets_install)
$(DUKE_PROXYJ)_install: extra = DUKEMAIMDIR=$(DUKEMAIMDIR)

$(targets_install):
	$(MAKE) -C $(@:%_install=%) $(extra) DESTDIR=$(DESTDIR) install

uninstall: $(targets_uninstall)
$(DUKE_PROXYJ)_uninstall: extra = DUKEMAIMDIR=$(DUKEMAIMDIR)

$(targets_uninstall):
	$(MAKE) -C $(@:%_uninstall=%) $(extra) uninstall

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
