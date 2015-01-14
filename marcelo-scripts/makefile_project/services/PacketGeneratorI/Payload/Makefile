LIBNAME= PacketGeneratorI
NAME=Payload

HEADERS= inc/*.h
ifdef SVOS
DESTDIR ?= /
endif

.PHONY: default all src src_clean clean_lib clean remove_dir config_files_cleanlib
default: all
all: src
src:
	@printf "\n%s\n\n" "********************* build $(NAME) **************************"
	$(MAKE) -C $@

clean: src_clean

src_clean:
	$(MAKE) -C $(@:%_clean=%) clean

clean_lib: remove_dir config_files_cleanlib

config_files_cleanlib:
	$(MAKE) -C ../../ConfigFiles/$(LIBNAME) clean_lib

remove_dir:
	rm -rf /usr/include/services/$(LIBNAME)/

install:
ifdef SVOS
	install -m 0444 $(HEADERS) $(DESTDIR)/usr/include/services/$(LIBNAME)/
	install -d $(DESTDIR)/usr/include/services/$(LIBNAME)/$(NAME)
else
	sudo cp -f $(HEADERS) /usr/include/services/$(LIBNAME)/
	sudo mkdir -p /usr/include/services/$(LIBNAME)/$(NAME)
endif
	$(MAKE) -C ../../ConfigFiles/$(LIBNAME)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
