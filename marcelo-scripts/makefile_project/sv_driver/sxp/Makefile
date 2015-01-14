subdirs = src api

.PHONY: all install clean $(subdirs)

MAKECMDGOALS := $(filter-out all,$(MAKECMDGOALS))
 
all install clean: $(subdirs)

$(subdirs):
	$(MAKE) -C $@ $(MAKECMDGOALS)


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
