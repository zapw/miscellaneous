exists := $(wildcard ./Makefile)
ifeq ($(exists),)
.PHONY: $(CURDIR) $(MAKECMDGOALS)
.DEFAULT_GOAL := $(CURDIR)
$(CURDIR): ;
$(MAKECMDGOALS): ;
endif

$(lastword $(MAKEFILE_LIST)): ;
