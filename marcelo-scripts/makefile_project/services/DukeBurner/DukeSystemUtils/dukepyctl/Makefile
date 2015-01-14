TARGET_DIR=target
PROG=dukepyctl
INSTALL_PATH=$(PROG)
MAKE_PROG=../script/create_executable.py
MAIN_PROG=dra.py
LOCAL_APP_DATA=appdata
BIN_DIR=/usr/local/bin
LOCAL_PROG=$(TARGET_DIR)/$(PROG)
GLOBAL_PROG=$(BIN_DIR)/$(PROG)

.PHONY: default
default: $(TARGET_DIR)/$(PROG) $(TARGET_DIR)/$(MAIN_PROG)

$(TARGET_DIR):
	-mkdir -p $(TARGET_DIR)

$(TARGET_DIR)/$(PROG): $(MAIN_PROG) | $(TARGET_DIR)
	$(MAKE_PROG) --appdata $(LOCAL_APP_DATA) --ld-path . --program $(LOCAL_PROG) --cmd 'python $(MAIN_PROG) $$*'

$(TARGET_DIR)/$(MAIN_PROG): | $(TARGET_DIR)
	cp $(MAIN_PROG) $(TARGET_DIR)

clean: 
	rm -rf $(TARGET_DIR)

install:
	mkdir -p $(DESTDIR)$(DUKEMAINDIR)$(INSTALL_PATH)
	mkdir -p $(DESTDIR)$(BIN_DIR)
	cp $(MAIN_PROG) $(DESTDIR)$(DUKEMAINDIR)$(INSTALL_PATH)
	$(MAKE_PROG) --program $(DESTDIR)$(GLOBAL_PROG) --cmd 'python $(DUKEMAINDIR)$(INSTALL_PATH)/$(MAIN_PROG) $$*'

uninstall: 
	rm -rf $(DUKEMAINDIR)$(INSTALL_PATH)
	rm -f $(GLOBAL_PROG)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
