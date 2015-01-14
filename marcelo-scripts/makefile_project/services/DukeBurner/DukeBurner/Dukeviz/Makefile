TARGET_DIR=target
INSTAL_DIR=/opt/dukeviz/
BIN_DIR=/usr/local/bin/
PROG=$(BIN_DIR)/dukeviz
CMD_LINE='java -jar $(INSTAL_DIR)/launcher.jar  $$*'

LAUNCHER_DIR=dukeviz-launcher
APP_DIR=dukeviz
dukeviz_jars = DukeBurner.jar jackson-annotations-2.5.0.jar  jackson-core-2.5.0.jar  jackson-databind-2.5.0.jar miglayout-core-4.2.jar  miglayout-swing-4.2.jar

.PHONY: all gadle_dukeviz

#check if any of the files in dukeviz_jars= variable are missing from $(TARGET_DIR)/ and if so run add 'gradle_dukeviz' prerequisit to 'all' target
ifneq '$(sort $(dukeviz_jars))' '$(sort $(filter $(dukeviz_jars),$(notdir $(wildcard $(TARGET_DIR)/*.jar))))'
all: gradle_dukeviz $(TARGET_DIR)/launcher.jar
else
all: $(TARGET_DIR)/launcher.jar
endif


$(TARGET_DIR):
	-mkdir -p $(TARGET_DIR)

$(TARGET_DIR)/launcher.jar: |  $(TARGET_DIR)
	gradle -p $(LAUNCHER_DIR) build -x test
	cp $(LAUNCHER_DIR)/build/libs/* $(TARGET_DIR)

gradle_dukeviz: | $(TARGET_DIR)
	gradle -p $(APP_DIR) build -x test
	cp $(APP_DIR)/build/libs/* $(TARGET_DIR)

clean: 
	gradle -p $(LAUNCHER_DIR) clean
	gradle -p $(APP_DIR) clean
	rm -rf $(TARGET_DIR)

install:
	mkdir -p $(DESTDIR)$(BIN_DIR) $(DESTDIR)$(INSTAL_DIR)
	cp $(LAUNCHER_DIR)/build/libs/* $(DESTDIR)$(INSTAL_DIR)
	cp $(APP_DIR)/build/libs/* $(DESTDIR)$(INSTAL_DIR)
	echo $(CMD_LINE) > $(DESTDIR)$(PROG)
	chmod 774 $(DESTDIR)$(PROG)

uninstall:
	rm -rf $(INSTAL_DIR)
	rm -f $(PROG)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
