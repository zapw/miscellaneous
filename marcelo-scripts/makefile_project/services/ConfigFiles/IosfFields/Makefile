
NAME:= IosfFields
SERVICES_GLOBAL_PATH:= /usr/include/services
SERVICES_CONFIG_GLOBAL_PATH:= $(SERVICES_GLOBAL_PATH)/ConfigFiles
SERVICES_CONFIG_OLD_GLOBAL_PATH:= $(SERVICES_GLOBAL_PATH)/$(NAME)
ifdef SVOS
DESTDIR ?= /
endif

.PHONY: install install_new install_old clean_lib cleanlib_new cleanlib_old
default: install

ifdef SVOS
install: install_new install_old
install_new:
	install -d $(DESTDIR)/$(SERVICES_CONFIG_GLOBAL_PATH)/ $(DESTDIR)/$(SERVICES_CONFIG_GLOBAL_PATH)/$(NAME)/
	rsync -a --exclude=CVS --exclude=Makefile* ./ $(DESTDIR)/$(SERVICES_CONFIG_GLOBAL_PATH)/$(NAME)/        

install_old:    
	install -d $(DESTDIR)/$(SERVICES_CONFIG_OLD_GLOBAL_PATH)/ $(DESTDIR)/$(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/ \
	$(DESTDIR)/$(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/prod/
	rsync -a --exclude=CVS --exclude=Makefile* ./ $(DESTDIR)/$(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/prod/
else
install: install_new install_old
install_new:
	sudo mkdir -p $(SERVICES_CONFIG_GLOBAL_PATH)/ $(SERVICES_CONFIG_GLOBAL_PATH)/$(NAME)/
	sudo rsync -a --exclude=CVS --exclude=Makefile* ./ $(SERVICES_CONFIG_GLOBAL_PATH)/$(NAME)/	

install_old:	
	sudo mkdir -p $(SERVICES_CONFIG_OLD_GLOBAL_PATH)/ $(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/ \
	$(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/prod/
	sudo rsync -a --exclude=CVS --exclude=Makefile* ./ $(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/prod/
endif

clean_lib: cleanlib_new cleanlib_old

cleanlib_new:
	sudo rm -rf $(SERVICES_CONFIG_GLOBAL_PATH)/$(NAME)
cleanlib_old:
	sudo rm -rf $(SERVICES_CONFIG_OLD_GLOBAL_PATH)/cfg/

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
#prevents implicit rule look-ups for Makefile.
Makefile: ;
