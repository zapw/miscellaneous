SUBDIRS = tests execution

.PHONY: all clean $(SUBDIRS)

MAKECMDGOALS := $(filter-out all,$(MAKECMDGOALS))
 
all clean: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
