.PHONY: dummygoal
dummygoal: ;

#Efficience tweaks:
.SUFFIXES:

#prevents implicit rule look-ups for Makefile.
Makefile: ;

ifeq ($(.DEFAULT_GOAL),dummygoal)
  .DEFAULT_GOAL :=
endif
