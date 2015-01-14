.PHONY: all default SRC
default: SRC
all:    SRC
		
define message

********************* build infrastructure unitests src**************************

endef

ifneq ($(filter all default,$(MAKECMDGOALS)),)
$(info $(message))
else ifeq ($(MAKECMDGOALS),)
$(info $(message))
endif

all install clean: SRC

SRC:
	$(MAKE) -C src $(MAKECMDGOALS)

include ../../misc.mk
