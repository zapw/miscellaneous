include $(dir $(lastword $(MAKEFILE_LIST)))../../Adapters.mk

ifdef SVOS
DESTDIR ?= /
endif

LIBS := $(strip $(LIBS))

ifeq ($(strip $(dirs)),)
 dirs := $(filter-out CVS/ inc/ include/,$(wildcard */))
endif

ifdef skip_dirs
 skip_dirs := $(wildcard $(addsuffix /,$(skip_dirs)))
 dirs := $(filter-out $(skip_dirs), $(dirs))
endif

base_paths := $(dirs)
base_paths_clean := $(base_paths:%=%_clean)

ifeq ($(filter-out default all -l$(NAME) $(TARGET_ST),$(MAKECMDGOALS)),)
ifndef MAKE_RESTARTS
Makefile: $(base_paths)
	@touch ./Makefile
$(base_paths):
	@printf "\n%s\n" "******************** Build $(ADAPTER_NAME)/$@ ********************"
	$(MAKE) -C $@
else
define recurse_dirs
tmp_dirs := $$(filter-out $(1)CVS/ $(1)inc/ $(1)include/,$$(filter %/,$$(wildcard $(1)*/)))
dirs += $$(tmp_dirs)
$$(foreach dirname,$$(tmp_dirs),$$(eval $$(call recurse_dirs,$$(dirname))))
endef
$(foreach dirname,$(dirs),$(eval $(call recurse_dirs,$(dirname))))

objects := $(wildcard $(addsuffix *.o,$(dirs)))
endif
endif


.PHONY: $(base_paths) $(base_paths_clean) all default clean rest message

TARGET_SO:=lib$(NAME).so.0.0
TARGET_ST:=lib$(NAME).a

default: -l$(NAME) $(TARGET_ST)
all: -l$(NAME) $(TARGET_ST)
message:
	$(message)

$(objects): ;

-l$(NAME): $(objects)
	$(CXX) -shared -Wl,-soname,lib$(NAME).so -o ./$(TARGET_SO) $(objects) $(LIBS)
	/sbin/ldconfig -n ./

$(TARGET_ST): $(objects)
	ar -rcs $(TARGET_ST) $(objects)

ifdef SVOS
install:
	install -d $(DESTDIR)/usr/lib64/
	install $(TARGET_SO) $(DESTDIR)/usr/lib64/
endif

clean: $(base_paths_clean) rest
$(base_paths_clean):
	$(MAKE) -C $(@:%_clean=%) clean
rest:
	rm -f *.so* *.a

%lib_second.mk: ;
.ONESHELL:
