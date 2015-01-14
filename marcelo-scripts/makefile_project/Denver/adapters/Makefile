include ../Adapters.mk
.PHONY: default all IPS clean

default: IPS
all: IPS

IPS: $(CORE_LIBS)
	@printf "\n%s\n" "********************* build IPs **************************"
	$(MAKE) -C IPs
		
clean:
	$(MAKE) -C IPs clean
