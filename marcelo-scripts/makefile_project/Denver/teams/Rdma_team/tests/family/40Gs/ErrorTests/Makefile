TEAM_NAME := Rdma_team
all_lib_inc = $(FINAL_TESTS_FAMILY_INC)
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
