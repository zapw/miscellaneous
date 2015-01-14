
NAME:= ConfigFiles
SERVICES_GLOBAL_PATH:= /usr/include/services/ConfigFiles

CONFIG_FILES_FOLDERS:= $(filter-out CVS/, $(sort $(wildcard */)))
CLEAN_LIB_FOLDERS := $(CONFIG_FILES_FOLDERS:%=clean_lib-%)

.PHONY: default install clean_lib remove $(CONFIG_FILES_FOLDERS) $(CLEAN_LIB_FOLDERS)
default: install

install: $(CONFIG_FILES_FOLDERS)

$(CONFIG_FILES_FOLDERS):
	@printf "\n%s\n" "******************** Build $(ConfigFiles)/$@ ********************"
	@$(MAKE) -C $@ install

clean_lib: remove $(CLEAN_LIB_FOLDERS)
remove:
	sudo rm -rf $(SERVICES_GLOBAL_PATH)/

$(CLEAN_LIB_FOLDERS):
	@$(MAKE) -C $(@:clean_lib-%=%) cleanlib_old
