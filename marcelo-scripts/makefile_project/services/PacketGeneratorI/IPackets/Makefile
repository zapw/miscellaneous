
LIBNAME= PacketGeneratorI
NAME=IPackets

ifdef SVOS
DESTDIR ?= /
endif



HEADERS= inc/*.h

.PHONY: default all src src_clean clean_lib clean
default: all
all: src
src:
	@printf "\n%s\n\n" "********************* build $(NAME) **************************"
	$(MAKE) -C $@

clean: src_clean

src_clean:
	$(MAKE) -C $(@:%_clean=%) clean

clean_lib:
	rm -rf /usr/include/services/$(LIBNAME)/

install:
ifdef SVOS
	install -m 0444 $(HEADERS) $(DESTDIR)/usr/include/services/$(LIBNAME)/
else
	sudo cp -f $(HEADERS) /usr/include/services/$(LIBNAME)/
endif

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
