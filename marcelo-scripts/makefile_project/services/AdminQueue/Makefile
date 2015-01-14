NAME := AdminQueue

TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

targets_so := $(TARGET_SO)
targets_so_preq := -lUtilities

include ../preq.mk

OBJECTS := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))

DIRS := src 
CLEANDIRS := $(DIRS:%=clean-%) 
CLEANDIRS += clean-Tests

ifdef SVOS
 DESTDIR ?= /
endif

LIBS :=   -lpcap -lc -lpci -lz -lboost_thread -lboost_filesystem -ldl 

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY: default all Tests remove remove_lib $(DIRS) $(CLEANDIRS) ../ConfigFiles/$(NAME) clean_lib other_install
default: all

all: $(TARGET_SO) $(TARGET_ST) Tests

NO_TESTS: $(TARGET_SO) $(TARGET_ST)

$(TARGET_SO): $(OBJECTS)
	$(CXX) -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	/sbin/ldconfig -n ./

$(TARGET_ST): $(OBJECTS)
	ar -rcs ./$(TARGET_ST) $(OBJECTS)

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	@printf "\n%s\n" "*******************compiling $(CURR_DIR)/$(@)*******************"
	$(MAKE) -C $@

Tests: $(TARGET_SO) -lUtilities

clean: $(CLEANDIRS) remove

remove:
	rm -f ./*.so* ./*.a*

install clean_lib: ../ConfigFiles/$(NAME)

install: other_install

clean_lib: remove_lib

other_install:
ifdef SVOS
	install -d $(DESTDIR)/usr/include/services/$(NAME)/
	install -m 0444 inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/
	install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
	install -d $(DESTDIR)/usr/include/services/$(NAME)
else
	sudo mkdir -p /usr/include/services/$(NAME)/
	sudo cp inc/*.h /usr/include/services/$(NAME)/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)	
endif

remove_lib:
	sudo rm -rf /usr/include/services/$(NAME) $(LIBS_DIR)/*lib$(NAME)*

../ConfigFiles/$(NAME):
	$(MAKE) -C ../ConfigFiles/$(NAME) $(filter clean_lib install,$(MAKECMDGOALS))

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean

$(eval $(auto_prerequisite_gen))
