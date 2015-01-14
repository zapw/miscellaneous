.PHONY: default all src clean
default: all

MAKECMDGOALS := $(filter-out all,$(MAKECMDGOALS))

all clean: src 
src:
	$(MAKE) -C $@ $(MAKECMDGOALS)
