.PHONY: default all clean clean_lib install TESTS SRC NO_TEST src Tests

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

src:
	$(MAKE) -C $@ $(filter clean clean_lib,$(MAKECMDGOALS))
	
clean clean_lib: src

clean: Tests
	
Tests:
	$(MAKE) -C $@ clean
