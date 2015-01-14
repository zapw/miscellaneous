TEAM_NAME := SWDenverCore_team
all_lib_inc = $(FINAL_TESTS_PRODUCT_INC)

define message
@echo "******************** $(CURDIR) ********************"

@echo "$(FINAL_TESTS_PRODUCT_INC)"
@echo HHHHHHHHHHHHHHHHHHHHHHHHHH
@echo "$(PATH_TO_ADAPTERCLASSES)"
@echo GGGGGGGGGGGGGGGGGGGGGGGGGGGGG
@echo "$(PATH_TO_FC_ADAPTERCLASSES)"
@echo KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
@echo "$(GENERIC_ADAPTERS_INC)"

endef

-include ../../../../../includes/team.mk

ifndef loaded
.PHONY: force
define find_team_mk
$(or $(wildcard $(1)),$(call find_team_mk,../$(1)))
endef

resolved_path := $(or $(wildcard ../../includes/team.mk),$(call find_team_mk,../../../includes/team.mk))
Makefile: force
	@sed -Ei 's:^-include (.*includes/team.mk):-include $(resolved_path):' ./Makefile
force: ;
endif
