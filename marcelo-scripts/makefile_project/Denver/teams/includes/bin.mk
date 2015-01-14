this_file := $(lastword $(MAKEFILE_LIST))
relative_path := $(dir $(this_file))
$(this_file): ;

.DEFAULT_GOAL := Denver

include $(relative_path)../../teams/$(TEAM_NAME)/my_team.mk
include $(relative_path)../../Teams.mk

ifeq ($(strip $(dirs)),)
 dirs := $(filter ../tests/ ../infrastructure/,$(wildcard ../*/))
endif

ifdef skip_dirs
 skip_dirs := $(wildcard $(addsuffix /,$(skip_dirs)))
 dirs := $(filter-out $(skip_dirs), $(dirs))
endif

base_paths := $(dirs)
clean_adapters := $(ALL_ADAPTERS:%=clean_%)
clean_base_paths := $(base_paths:%=clean_%)

ifeq ($(filter-out default all $(EXE_NAME),$(MAKECMDGOALS)),)
ifndef MAKE_RESTARTS
Makefile: $(base_paths)
	@touch ./Makefile
$(base_paths):
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

.PHONY: message install install_adapters clean clean_adapters clean_core clean_lib_core clean_all clean_combined $(ALL_ADAPTERS) $(CORE_ROOT) $(base_paths) $(clean_base_paths) $(clean_adapters) $(install_adapters) adapters core

sources := $(wildcard *.cpp)
bin_objects := $(sources:%.cpp=%.o)

all_lib_inc := $(strip $(all_lib_inc) $(FINAL_BIN_INC))

LIBS := $(strip $(LIBS) $(FINAL_LIBS))

CXXFLAGS += $(DBG)

default: $(EXE_NAME)
all: $(EXE_NAME) 
message:
	$(message)

$(objects): ;

$(EXE_NAME): $(objects) $(bin_objects)
	$(CXX) $(CXXFLAGS) -o $(EXE_NAME) $(objects) $(bin_objects) $(LIBS) $(LDFLAGS) $(LDLIBS) -rdynamic

core:
	$(MAKE) -C $(CORE_ROOT)
adapters: $(ALL_ADAPTERS)
$(ALL_ADAPTERS):
	$(MAKE) -C $@

ifdef SVOS
install_adapters := $(ALL_ADAPTERS:%=install_%)
install_adapters: $(install_adapters)
$(install_adapters):
	$(MAKE) -C $(@:install_%=%) install

all_lib_inc += -I/usr/include/svos/ -I/usr/include/svos/sv/
CXXFLAGS += -DSVOS

install:
	install -d $(DESTDIR)/usr/bin/$($(TEAM_NAME))
	install $(EXE_NAME) $(DESTDIR)/usr/bin/$($(TEAM_NAME))/
ifneq ($(wildcard toss*.xml),)
	install -d $(DESTDIR)/etc/toss/$($(TEAM_NAME))/
	install -m 0644 toss*.xml $(DESTDIR)/etc/toss/$($(TEAM_NAME))/
endif
endif

ifndef SVOS
install:
	sudo cp $(EXE_NAME) /usr/bin/$(EXE_NAME)
endif

clean:
	rm -f *.o $(EXE_NAME) .*.d $(includes)

clean_adapters: $(clean_adapters)
$(clean_adapters):
	$(MAKE) -C $(@:clean_%=%) clean

$(clean_base_paths):
	$(MAKE) -C $(@:clean_%=%) clean

clean_combined:
	$(MAKE) -C $(CORE_ROOT) clean clean_lib

clean_core:
	$(MAKE) -C $(CORE_ROOT) clean

clean_lib_core:
	$(MAKE) -C $(CORE_ROOT) clean_lib

clean_all: clean $(clean_adapters) $(clean_base_paths) clean_combined

$(eval $(auto_prerequisite_gen))

%my_team.mk: ;
