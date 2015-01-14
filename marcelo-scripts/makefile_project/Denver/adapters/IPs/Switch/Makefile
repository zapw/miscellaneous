include ../../../Adapters.mk
.PHONY: default all HLPS clean
default: HLPS

all: HLPS

HLPS: $(CORE_LIBS)
	@printf "\n%s\n" "********************* build HLPs **************************"
	$(MAKE) -C HLPs	
		
clean:
	$(MAKE) -C HLPs clean
