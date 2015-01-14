dirs := adapters/src SyntheticTest/src
dirs_clean := $(dirs:%=%_clean) src_clean
.PHONY: all default src src_dir $(dirs) $(dirs_clean) adapters synthetic

default: $(dirs) src_dir
all: $(dirs) src_dir

$(dirs):
	$(MAKE) -C $@
src_dir:
	$(MAKE) -C $(@:%_dir=%)

src: src_dir
adapters: SyntheticTest/src src_dir
synthetic: SyntheticTest/src

clean: $(dirs_clean)
$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean

include ../../misc.mk
