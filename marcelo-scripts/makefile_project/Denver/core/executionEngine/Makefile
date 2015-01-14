.PHONY: rocket clean src default all src_clean rocket_clean
include ../Core.mk

default: all
ifdef SVOS
all: src rocket
clean: rocket_clean
else
all: src 
endif 

src:		
	@printf "\n%s\n" "********************* build $(CURDIR) **************************"
	$(MAKE) -C $@

rocket:
	@printf "\n%s\n" "********************* build rocket **************************"
	@$(MAKE) -C $@

clean: src_clean

src_clean rocket_clean:
	$(MAKE) -C $(@:%_clean=%) clean

include ../../misc.mk
