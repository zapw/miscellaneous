.PHONY: all default src
default: src
all: src

src:		
	@printf "\n%s\n" "********************* build $(CURDIR) **************************"
	$(MAKE) -C $@

clean:
	$(MAKE) -C src clean

include ../../../misc.mk
