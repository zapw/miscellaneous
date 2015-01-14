include ../../Adapters.mk

dirs := MstDesign Generic
dirs_clean := $(dirs:%=%_clean)

.PHONY: default all clean $(dirs) $(dirs_clean)
default: all

all: $(dirs)
$(dirs): $(CORE_LIBS)
	@printf "\n%s\n" "********************* build $@ **************************"
	$(MAKE) -C $@

Generic_LAD: Generic

clean: $(dirs_clean)
$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean
