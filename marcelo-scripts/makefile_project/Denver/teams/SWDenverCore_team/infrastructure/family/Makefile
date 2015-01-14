-include ../../../includes/submake.mk

ifndef loaded
.PHONY: force
define find_submake_mk
$(or $(wildcard $(1)),$(call find_submake_mk,../$(1)))
endef

resolved_path := $(or $(wildcard ../../includes/submake.mk),$(call find_submake_mk,../../../../includes/submake.mk))
Makefile: force
	@sed -Ei 's:^-include (.*includes/submake.mk):-include $(resolved_path):' ./Makefile
force: ;
endif
