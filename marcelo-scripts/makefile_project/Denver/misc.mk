#Efficience tweaks:
#disable implicit rule look-ups
.SUFFIXES:

#disables implicit rule look-ups for re-generating Makefile and this misc.mk file.
%Makefile: ;
%misc.mk: ;
