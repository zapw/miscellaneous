TEAM_NAME= SVShared_team

CURRENT_DIR:=$(shell pwd)
ifdef SVOS
CURRENT_DENVER_ROOT:=$(shell echo $(CURRENT_DIR) | sed -e 's/\([^/\]*denver[^/\]*\)\/teams\/*.*/\1/I')
else
CURRENT_DENVER_ROOT:=$(shell echo $(CURRENT_DIR) | sed -e 's/Denver\/teams\/*.*/Denver/')
endif

include $(CURRENT_DENVER_ROOT)/Teams.mk
include $(TEAM_ROOT)/my_team.mk

INC := $(FINAL_TESTS_PRODUCT_INC)
OBJS := $(patsubst %.cpp,%.o,$(sort $(wildcard *.cpp)))

FOLDERS := $(filter-out CVS/ inc/, $(sort $(wildcard */)))
CLEAN_FOLDERS := $(FOLDERS:%=clean-%)
CPPS := $(wildcard *.cpp)

%.o: %.cpp
	@echo $(CC) $(CFLAGS) $(DBG) -c $<
	@$(CC) $(INC) $(CFLAGS) $(DBG) -c $<

default: all

all: prepare $(OBJS) $(FOLDERS)

clean:
	#rm -f *.o dep
	#$(if $(FOLDERS), make $(CLEAN_FOLDERS))
	find . -name 'dep' -delete
	find . -name '*.o' -delete

.PHONY: prepare
prepare:
	@echo
	@echo "******************** $(CURDIR) ********************"
	@echo

.PHONY: $(FOLDERS)
$(FOLDERS):
	@$(MAKE) -C $@

.PHONY: $(CLEAN_FOLDERS)
$(CLEAN_FOLDERS):
	@$(MAKE) -C $(@:clean-%=%) clean

dep: $(CPPS)
	@$(if $(CPPS),$(CC) $(INC) -M *.cpp > dep,touch dep)

-include dep

