NAME := client

OBJECTS := src/client.o

DIRS := src 
CLEANDIRS := $(DIRS:%=clean-%) 

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif


.PHONY: default all $(DIRS) $(CLEANDIRS) tests clean-tests remove
default: all

all:  tests #$(TARGET_ST) $(TARGET_SO)

NO_TESTS: #$(TARGET_ST) $(TARGET_SO)
	
$(TARGET_SO): $(OBJECTS)
	$(CXX) $(FINAL_LIBS)  -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS)
	/sbin/ldconfig -n ./

$(TARGET_ST): $(OBJECTS)
	ar -rcs ./$(TARGET_ST) $(OBJECTS)

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	@printf "\n%s\n" "*******************compiling $(CURDIR)/$(@)*******************"
	$(MAKE) -C $@
tests:
	$(MAKE) -C $@

clean: $(CLEANDIRS) clean-tests remove

clean_lib:
remove:
	rm -f ./*.so.* ./*.so ./*.a.* ./*.a *.o $(includes)

install: config_files install_files

install_files:

$(CLEANDIRS) clean-tests:
	$(MAKE) -C $(@:clean-%=%) clean

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
