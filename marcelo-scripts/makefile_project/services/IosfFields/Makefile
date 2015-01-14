.PHONY: all default SRC TESTS install clean src-clean Tests-clean

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

clean: src-clean Tests-clean

src-clean:
	$(MAKE) -C src clean

Tests-clean:
	$(MAKE) -C Tests clean
	

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
