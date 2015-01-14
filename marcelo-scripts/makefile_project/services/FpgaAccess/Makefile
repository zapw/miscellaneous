PY_INSTALL_PATH:=$(shell  python -c "import sys; print [f for f in sys.path if f.endswith('packages')][0]")
ifdef SVOS
DESTDIR ?= /
endif

dirs = duke_proxy veloce_proxy FpgaAccessApi genesys_proxy/src ftdi_driver
clean_dirs = $(patsubst %,clean-%,$(dirs))
ifndef SVOS
dirs += misc_apps
misc_apps: FpgaAccessApi duke_proxy veloce_proxy genesys_proxy/src
endif

.PHONY: all default clean install $(dirs) $(clean_dirs) ftdi_driver install_rest ftdi_driver-install ftdi_driver-cleanlib rest-cleanlib
default: all

all: $(filter-out ftdi_driver,$(dirs))

ifdef SVOS
misc_apps veloce_proxy genesys_proxy:
else
misc_apps veloce_proxy genesys_proxy: ftdi_driver
endif

$(dirs):
	$(MAKE) -C $@

ftdi_driver-install:
	$(MAKE) -C ftdi_driver install

FpgaAccessApi: duke_proxy genesys_proxy/src/ veloce_proxy

clean: $(clean_dirs)

$(clean_dirs):
	$(MAKE) -C $(@:clean-%=%) clean

install: ftdi_driver-install install_rest
install_rest:
ifdef SVOS
	install -d $(DESTDIR)/usr/include/fpga_access
	install genesys_proxy/src/libgenesys_proxy.so.0.0 $(DESTDIR)/usr/lib64
	install duke_proxy/libDukeProxy.so.0.0  $(DESTDIR)/usr/lib64
	install veloce_proxy/libVeloceProxy.so.0.0  $(DESTDIR)/usr/lib64
	install FpgaAccessApi/libFpgaRegisterAccessApi.so.0.0 $(DESTDIR)/usr/lib64
	install -m 0444 duke_proxy/duke_proxy.h $(DESTDIR)/usr/include/fpga_access/
	install -m 0444 veloce_proxy/veloce_proxy.h $(DESTDIR)/usr/include/fpga_access/
	install -m 0444 genesys_proxy/inc/CFtdiWrapper.h $(DESTDIR)/usr/include/fpga_access/ 
	install -m 0444 FpgaAccessApi/*.h $(DESTDIR)/usr/include/fpga_access/   #/usr/include/services/liteignite/
else
	sudo mkdir -p $(DESTDIR)/usr/lib64
	sudo mkdir -p $(DESTDIR)/usr/bin
	sudo mkdir -p $(DESTDIR)/usr/include/fpga_access
	sudo mkdir -p $(DESTDIR)/$(PY_INSTALL_PATH)
	sudo mkdir -p $(DESTDIR)/usr/include/services/liteignite/

	sudo cp genesys_proxy/src/libgenesys_proxy.so.0.0       $(DESTDIR)/usr/lib64
	sudo ln -sf /usr/lib64/libgenesys_proxy.so.0.0          $(DESTDIR)/usr/lib64/libgenesys_proxy.so
	sudo cp duke_proxy/libDukeProxy.so.0.0                  $(DESTDIR)/usr/lib64
	sudo ln -sf /usr/lib64/libDukeProxy.so.0.0              $(DESTDIR)/usr/lib64/libDukeProxy.so
	sudo cp veloce_proxy/libVeloceProxy.so.0.0              $(DESTDIR)/usr/lib64
	sudo ln -sf /usr/lib64/libVeloceProxy.so.0.0            $(DESTDIR)/usr/lib64/libVeloceProxy.so
	sudo cp FpgaAccessApi/libFpgaRegisterAccessApi.so.0.0   $(DESTDIR)/usr/lib64
	sudo ln -sf /usr/lib64/libFpgaRegisterAccessApi.so.0.0  $(DESTDIR)/usr/lib64/libFpgaRegisterAccessApi.so
	sudo cp misc_apps/lfpga_burner                          $(DESTDIR)/usr/bin
	sudo cp misc_apps/fpga_reset                            $(DESTDIR)/usr/bin
	sudo cp misc_apps/_fpga_register_access_py.so           $(DESTDIR)/$(PY_INSTALL_PATH)
	sudo cp misc_apps/fpga_register_access_py.py            $(DESTDIR)/$(PY_INSTALL_PATH)
endif
	sudo cp duke_proxy/duke_proxy.h                         $(DESTDIR)/usr/include/fpga_access/
	sudo cp veloce_proxy/*.h	                  	$(DESTDIR)/usr/include/fpga_access/
	sudo cp genesys_proxy/inc/CFtdiWrapper.h                $(DESTDIR)/usr/include/fpga_access/ 
	sudo cp FpgaAccessApi/*.h                               $(DESTDIR)/usr/include/fpga_access/

clean_lib: ftdi_driver-cleanlib rest-cleanlib
rest-cleanlib:
	sudo rm -rf /usr/include/fpga_access/ /usr/include/services/liteignite/ /usr/lib64/libgenesys_proxy.so*
	sudo rm -f  /usr/lib64/libDukeProxy.so* /usr/lib64/libVeloceProxy.so* /usr/lib64/libFpgaRegisterAccessApi.so* /usr/bin/lfpga_burner \
	/usr/bin/fpga_reset $(PY_INSTALL_PATH)/_fpga_register_access_py.so $(PY_INSTALL_PATH)/fpga_register_access_py.py

ftdi_driver-cleanlib:
	$(MAKE) -C ftdi_driver clean_lib
