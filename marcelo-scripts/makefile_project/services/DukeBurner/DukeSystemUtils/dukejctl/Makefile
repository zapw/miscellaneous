TARGET_DIR=target
PROG=dukejctl
INSTALL_PATH=$(PROG)
MAKE_PROG=../script/create_executable.py
MAIN_PROG=duke-controller.jar
LOCAL_APP_DATA=appdata
BIN_DIR=/usr/local/bin
LOCAL_PROG=$(TARGET_DIR)/$(PROG)
GLOBAL_PROG=$(BIN_DIR)/$(PROG)

.PHONY: default clean install uninstall

default: $(LOCAL_PROG)
$(LOCAL_PROG): ../duke-proxy/duke-proxyj/duke-proxy/build/libs/duke-proxy.jar | $(TARGET_DIR)
	gradle build -x test
	cp build/libs/* $(TARGET_DIR)
	$(MAKE_PROG) --appdata $(LOCAL_APP_DATA) --ld-path . --program $(LOCAL_PROG) --cmd 'java -jar $(MAIN_PROG) $$*'

$(TARGET_DIR):
	-mkdir -p $(TARGET_DIR)

../duke-proxy/duke-proxyj/duke-proxy/build/libs/duke-proxy.jar:
	$(MAKE) -C ../duke-proxy/duke-proxyj duke-proxy/build/libs/duke-proxy.jar

clean: 
	gradle clean
	rm -rf $(TARGET_DIR)

install:
	mkdir -p $(DESTDIR)$(BIN_DIR) $(DESTDIR)$(DUKEMAINDIR)$(INSTALL_PATH)
	cp build/libs/* $(DESTDIR)$(DUKEMAINDIR)$(INSTALL_PATH)
	$(MAKE_PROG) --program $(DESTDIR)$(GLOBAL_PROG) --cmd 'java -jar $(DUKEMAINDIR)$(INSTALL_PATH)/$(MAIN_PROG) $$*'

uninstall: 
	rm -rf $(DUKEMAINDIR)$(INSTALL_PATH)
	rm -f $(GLOBAL_PROG)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
