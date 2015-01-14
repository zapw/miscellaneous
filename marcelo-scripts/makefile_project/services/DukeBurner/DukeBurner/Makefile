PREFS=dukejni dukeviz
DUKEVIZ=Dukeviz
DUKE_PROXY=DukeProxy
TARGET_DIR=target
INSTAL_ROOT_PATH=/opt
INSTAL_DIR=dukeviz
INSTAL_PATH=$(INSTAL_ROOT_PATH)/$(INSTAL_DIR)
SCRIPT_DIR=Script
PROG=DukeBurner
MAIN_LIB=launcher.jar
BIN_DIR=/usr/local/bin
LOCAL_MAIN_LIB=$(MAIN_LIB)
GLOBAL_MAIN_LIB=$(INSTAL_PATH)/$(MAIN_LIB)
LOCAL_PROG=$(TARGET_DIR)/$(PROG)
GLOBAL_PROG=$(BIN_DIR)/$(PROG)
SOURCE_VERSION_MARK_FILE_JAVA=./Dukeviz/dukeviz/src/main/java/com/intel/duke/control/CmdLine.java
OLD_PROG_REMOVER=$(SCRIPT_DIR)/uninstall_duke_burner1_5.sh
UPDATABLE_C_LIBS_DIR=Dukeviz/dukeviz/src/main/resources/clib/

default: $(LOCAL_PROG)
	cp $(DUKE_PROXY)/target/* $(TARGET_DIR)
	cp $(DUKEVIZ)/target/* $(TARGET_DIR)


$(LOCAL_PROG): $(DUKE_PROXY)/$(TARGET_DIR)/libDukeProxyJNI.so $(DUKEVIZ)/$(TARGET_DIR)/$(MAIN_LIB) | $(TARGET_DIR)
	$(SCRIPT_DIR)/create_executable.py -c 'java -jar $(LOCAL_MAIN_LIB) $$*' -p $(LOCAL_PROG) -l .

$(TARGET_DIR):
	-mkdir -p $@

install:
	mkdir -p $(DESTDIR)$(BIN_DIR) $(DESTDIR)$(INSTAL_PATH)
	chmod g+w $(DESTDIR)$(INSTAL_PATH)
	cp $(DUKEVIZ)/target/* $(DUKE_PROXY)/target/* $(DESTDIR)$(INSTAL_PATH)
	@$(SCRIPT_DIR)/create_executable.py -c 'java -jar $(GLOBAL_MAIN_LIB) $$*' -p $(DESTDIR)$(GLOBAL_PROG) -l $(INSTAL_PATH)

uninstall:
	rm -rf $(INSTAL_PATH)
	rm -f  $(GLOBAL_PROG)

uninstall-v1.5:
	@$(OLD_PROG_REMOVER) --force

source-mark:
	@$(SCRIPT_DIR)/update_source_version_mark.py -f $(SOURCE_VERSION_MARK_FILE_JAVA)

copy-updatable-clibs:
	$(SCRIPT_DIR)/copy_windows_updatable_products.sh $(UPDATABLE_C_LIBS_DIR)

source-unmark:
	git checkout $(SOURCE_VERSION_MARK_FILE_JAVA)

$(DUKE_PROXY)/$(TARGET_DIR)/libDukeProxyJNI.so:
	$(MAKE) -C $(DUKE_PROXY)

$(DUKEVIZ)/$(TARGET_DIR)/$(MAIN_LIB):
	$(MAKE) -C $(DUKEVIZ)

clean: $(DUKEVIZ) $(DUKE_PROXY)
	rm -rf $(TARGET_DIR)

$(DUKEVIZ) $(DUKE_PROXY):
	$(MAKE) -C $@ clean


.PHONY: $(DUKEVIZ) $(DUKE_PROXY) default

include ../../misc.mk
