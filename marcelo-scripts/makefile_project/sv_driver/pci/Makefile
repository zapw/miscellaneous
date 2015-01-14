SUBDIRS = src api

.PHONY: all install clean $(SUBDIRS)

MAKECMDGOALS := $(filter-out all,$(MAKECMDGOALS))
 
all install clean: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
