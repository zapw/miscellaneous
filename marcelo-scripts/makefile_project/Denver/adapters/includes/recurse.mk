this_file := $(lastword $(MAKEFILE_LIST))
export MAKEFILES := ../$(dir $(this_file))end.mk

ifndef dirs
 dirs := $(filter-out CVS/ inc/ include/,$(wildcard */))
endif

ifdef skip_dirs
 skip_dirs := $(wildcard $(addsuffix /,$(skip_dirs)))
 dirs := $(filter-out $(skip_dirs), $(dirs))
endif

dirs_clean := $(dirs:%=%_clean)

default: $(dirs)
all: $(dirs)

clean: $(dirs_clean)

.PHONY: $(dirs) $(dirs_clean)

$(dirs):
	$(MAKE) -C $@

$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean

$(this_file): ;
