include ../../Adapters.mk
.PHONY: default all ETH clean

default: ETH
all: ETH

ETH: $(CORE_LIBS)
	@printf "\n%s\n" "********************* build Eth **************************"
	$(MAKE) -C Eth
		
clean:
	$(MAKE) -C Eth clean

include ../../misc.mk
