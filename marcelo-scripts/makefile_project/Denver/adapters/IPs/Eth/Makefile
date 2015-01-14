include ../../../Adapters.mk

dirs := 10Gs 1Gs 40Gs BMC Generic Rdma
dirs_clean := $(dirs:%=%_clean)

.PHONY: default all clean $(dirs) $(dirs_clean)
default: all

all: $(dirs)
$(dirs): $(CORE_LIBS)
	@printf "\n%s\n" "********************* build $@ **************************"
	$(MAKE) -C $@
		
10G_LAD10GIG: 10Gs
1G_LAD1GIG:  1Gs
RDMA: Rdma
40G_LAD: 40Gs
BMC_LAD: BMC
Generic_LAD: Generic

clean: $(dirs_clean)
$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean
