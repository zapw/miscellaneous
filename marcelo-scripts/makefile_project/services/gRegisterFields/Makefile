.PHONY: default all SRC TESTS install clean Tests src
default: all

all: SRC TESTS
NO_TESTS: SRC

SRC:
	@printf "\n%s\n" "********************* build sources **************************"
	$(MAKE) -C src

TESTS: SRC
	@printf "\n%s\n" "********************* build tests **************************"
	$(MAKE) -C Tests

install:
	$(MAKE) -C src install

clean: Tests src

Tests src:
	$(MAKE) -C $@ clean
