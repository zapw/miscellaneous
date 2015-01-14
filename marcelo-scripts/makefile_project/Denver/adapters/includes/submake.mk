this_file := $(lastword $(MAKEFILE_LIST))
relative_path := $(dir $(this_file))
$(this_file): ;
ifeq ($(.DEFAULT_GOAL),$(this_file))
 .DEFAULT_GOAL :=
endif

export MAKEFILES := ../$(relative_path)end.mk

ifndef dirs
 dirs := $(filter-out CVS/ inc/ include/,$(wildcard */))
endif

ifdef skip_dirs
 skip_dirs := $(wildcard $(addsuffix /,$(skip_dirs)))
 dirs := $(filter-out $(skip_dirs), $(dirs))
endif

dirs_clean := $(dirs:%=%_clean)

.PHONY: default all $(dirs) $(dirs_clean)

default: $(dirs)
all: $(dirs)

$(dirs):
	$(MAKE) -C $@

clean: $(dirs_clean)
$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean

include $(relative_path)../../misc.mk

loaded := 1
