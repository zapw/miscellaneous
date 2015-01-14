.PHONY: default all dnet install_no_tests install clean clean_lib

default: all

all: dnet
NO_TESTS: dnet

install_no_tests install clean clean_lib: dnet

dnet:
ifeq ($(MAKECMDGOALS),)
	@printf "\n%s\n" "********************* build dnet app **************************"
endif
	$(if $(filter dnet all NO_TESTS,$(MAKECMDGOALS)),@printf "\n%s\n" "********************* build dnet app **************************")
	$(MAKE) -C $@ $(MAKECMDGOALS)
