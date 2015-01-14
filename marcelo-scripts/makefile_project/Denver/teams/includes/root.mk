this_file := $(lastword $(MAKEFILE_LIST))
relative_path := $(dir $(this_file))
$(this_file): ;
ifeq ($(.DEFAULT_GOAL),$(this_file))
 .DEFAULT_GOAL :=
endif

dirs := infrastructure tests
dirs_clean := $(dirs:%=%_clean)
default: bin
all: bin
ALL: bin

.PHONY: ALL default ADP_TEAM all $(dirs) $(dirs_clean) bin_clean_all bin_clean_adapters bin_clean_core bin adap core tm team adapters ALL_CR ALL_ADP ALL_TM clean_all clean_ALL clean_ADAPTERS clean_CORE  \
	clean clean_core clean_adapters clean_bin clean_team clean_lib clean_lib_core install

bin:
	$(MAKE) -C $@
core:
	$(MAKE) -C bin core

ADP_TEAM: core
	$(MAKE) -C bin adapters

$(dirs):
	$(MAKE) -C $@

$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean

clean_bin:
	$(MAKE)  -C $(@:clean_%=%) clean

bin_clean_all:
	$(MAKE)  -C $(@:%_clean_all=%) clean_all

bin_clean_core:
	$(MAKE)  -C $(@:%_clean_core=%) clean_core

bin_clean_adapters:
	$(MAKE)  -C $(@:%_clean_adapters=%) clean_adapters

ifdef SVOS
install:
	$(MAKE) -C bin install install_adapters
endif

adap: adapters
tm: $(dirs)
team: $(dirs)
adapters: core
	$(MAKE) -C bin adapters
ALL_CR: bin
ALL_ADP: bin
ALL_TM: bin

clean: bin_clean_all
clean_all: bin_clean_all
clean_ALL: clean_all
clean_ADAPTERS: clean_adapters
clean_CORE: clean_core
clean_core: bin_clean_core
clean_adapters: bin_clean_adapters
clean_team: $(dirs_clean)

clean_lib: clean_lib_core
clean_lib_core:
	$(MAKE) -C bin clean_lib_core

include $(relative_path)../../misc.mk
