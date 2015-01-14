SCRIPT_DIR=./Script
RPN_SCRIPT=$(SCRIPT_DIR)/create_proj_rpm.sh
FPGA_TOOLS=FpgaTools
DUKEBURNER=DukeBurner
DUKE_UTILS=DukeSystemUtils
TEST_DIR=Test
EXPORTS=/etc/profile.d/cseexports.sh


.PHONY: dukeviz dukeviz-full install uninstall clean dukeviz-official-jar install-ft-internal install-java-tools dukeutils clean-dukeutils install-dukeutils uninstall-dukeutils
dukeviz:
	$(MAKE) -C $(DUKEBURNER)

dukeviz-full: install-ft-internal install-java-tools
	source $(EXPORTS);  $(MAKE) -C $(DUKEBURNER)

install: dukeviz
	sudo -E  $(DUKEBURNER)/Script/uninstall_duke_burner1_5.sh
	sudo -E $(MAKE) -C $(DUKEBURNER) install

uninstall:
	sudo -E $(MAKE) -C $(DUKEBURNER) uninstall

clean:
	$(MAKE) -C $(DUKEBURNER) clean

dukeviz-official-jar:
	$(MAKE) -C $(DUKEBURNER) source-mark copy-updatable-clibs default
	$(SCRIPT_DIR)/copy_dukeburner_jar.sh

install-ft-internal:
	sudo -E $(SCRIPT_DIR)/install_ftd2xx_from_internal_server.sh --prefix $(DESTDIR)
	
install-java-tools:
	sudo -E $(SCRIPT_DIR)/install_maven_gradle.sh --tool gradle

dukeutils:
	$(MAKE) -C $(DUKE_UTILS)

clean-dukeutils:
	$(MAKE) -C $(DUKE_UTILS) clean

install-dukeutils:
	sudo -E $(MAKE) -C $(DUKE_UTILS) install

uninstall-dukeutils:
	sudo -E $(MAKE) -C $(DUKE_UTILS) uninstall

all: dukeviz dukeutils

.PHONY: remove
clean-all: clean clean-dukeutils remove

remove:
	rm -rf *.rpm *.tar.gz ftd2xx

install-all: install install-dukeutils 

uninstall-all: uninstall uninstall-dukeutils

rpm-dukeutils:
	$(RPN_SCRIPT) dukeutils

rpm-dukeviz:
	$(MAKE) -C $(DUKEBURNER) source-mark
	$(RPN_SCRIPT) dukeviz

rpms:
	$(MAKE) -C $(DUKEBURNER) source-mark
	$(RPN_SCRIPT) all

test:
	$(MAKE) -C $(TEST_DIR)

test-clean:
	$(MAKE) -C $(TEST_DIR) clean

install-official-dukeviz:
	sudo $(PSWITCHER) -i official

uninstall-official-dukeviz:
	sudo $(PSWITCHER) -r official

regression: dukeviz install
	$(MAKE) -C $(TEST_DIR) default run

regression-clean: uninstall install-official-dukeviz

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
