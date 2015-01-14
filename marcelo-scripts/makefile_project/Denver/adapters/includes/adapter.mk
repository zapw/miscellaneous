this_file := $(lastword $(MAKEFILE_LIST))
relative_path := $(dir $(this_file))
$(this_file): ;
ifeq ($(.DEFAULT_GOAL),$(this_file))
 .DEFAULT_GOAL :=
endif

.PHONY: default all clean
sources := $(wildcard *.cpp)
ifeq ($(sources),)
include $(relative_path)recurse.mk
include $(relative_path)../../misc.mk
else
adapter_dir := $(relative_path)../../adapters/$(ADAPTER_NAME)
include $(relative_path)../../Adapters.mk
include $(relative_path)recurse.mk

all_lib_inc := $(strip $(all_lib_inc))

objects := $(patsubst %.cpp,%.o,$(sources))

CXXFLAGS += $(DBG)

.PHONY: rest message
default: $(objects)
all: $(objects)
message:
	$(message)


clean: rest
rest:
	rm -f *.o .*.d $(includes)

$(eval $(auto_prerequisite_gen))

endif

loaded := 1
