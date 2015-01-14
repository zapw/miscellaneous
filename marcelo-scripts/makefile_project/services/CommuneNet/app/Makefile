DIRS = src 
CLEANDIRS = $(DIRS:%=clean-%) 

ifdef SVOS
DESTDIR ?= /
endif

.PHONY:	$(DIRS) $(CLEANDIRS) all default NO_TESTS clean install

default: all

all: $(DIRS)

NO_TESTS: $(DIRS)

clean: $(CLEANDIRS)
	
install:
ifdef SVOS 
	install -d $(DESTDIR)/usr/include/services/CommuneNet/app/InputFiles
	install InputFiles/*.xsd $(DESTDIR)/usr/include/services/CommuneNet/app/InputFiles/
else
	sudo mkdir -p /usr/include/services/CommuneNet/app/InputFiles
	sudo cp InputFiles/*.xsd /usr/include/services/CommuneNet/app/InputFiles/
endif		


clean_lib: 
	sudo rm -f /usr/include/services/CommuneNet/app/InputFiles/*.xsd
	
$(DIRS): 
	@echo 
	@echo "*******************compiling $(CURR_DIR)/$(@)*******************"
	@echo 
	$(MAKE) -C $@

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
