
all_targets = api driver tools unittest
clean_targets = $(patsubst %,%_clean,api driver tools)
install_targets =  $(patsubst %,%_install,api driver tools)

.PHONY:  API TOOLS DRIVER $(all_targets) $(clean_targets) $(install_targets)

all: $(all_targets)

$(all_targets):
	$(MAKE) -C $@

DRIVER:driver
API:api
TOOLS:tools

clean: $(clean_targets)

$(clean_targets):
	$(MAKE) -C $(@:%_clean=%) clean

install: $(install_targets)
	$(MAKE) -C $(@:%_install=%) install

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
