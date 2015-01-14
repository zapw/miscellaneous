.PHONY: default all install clean src Tests remove SRC TESTS NO_TESTS

default: all

all: SRC TESTS
NO_TESTS: SRC

SRC:
	@echo
	@echo "********************* build sources **************************"
	@echo
	$(MAKE) -C src

TESTS: SRC
	@echo
	@echo "********************* build tests **************************"
	@echo
	$(MAKE) -C Tests

install:
	$(MAKE) -C src install


clean: src Tests remove

remove:
	rm -f TCL/*.cxx

src Tests:
	$(MAKE) -C $@ clean

include ../misc.mk
