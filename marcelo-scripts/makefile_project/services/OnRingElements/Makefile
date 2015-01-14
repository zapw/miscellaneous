.PHONY:  default all NO_TESTS SRC TESTS install clean remove src Tests

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

clean: src Tests remove

remove:
	rm -f TCL/*.cxx

src Tests:
	$(MAKE) -C $@ clean
