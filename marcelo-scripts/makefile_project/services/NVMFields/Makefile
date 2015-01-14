NAME := NVMFields

TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

OBJECTS := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))

DIRS := src 
CLEANDIRS = $(DIRS:%=clean-%) 

ifdef SVOS
 DESTDIR ?= /
endif

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/  -L/usr/share/pvm3/lib/LINUXX86_64/  -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3  -lgpvm3
FINAL_LIBS := $(EXT_LIBS) $(PVM_LIBS)

targets_so :=  $(TARGET_SO)
$(TARGET_SO)_preq := -lUtilities
include ../preq.mk

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY: default all $(DIRS) $(CLEANDIRS) tests clean-tests remove config_files install_files
default: all

all: $(TARGET_ST) $(TARGET_SO) tests

NO_TESTS: $(TARGET_ST) $(TARGET_SO)

$(TARGET_SO): $(OBJECTS)
	$(CXX)  -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)
	ldconfig -n ./

$(TARGET_ST): $(OBJECTS)
	ar -rcs ./$(TARGET_ST) $(OBJECTS)

$(OBJECTS): | $(DIRS) ;

$(DIRS): 
	@printf "\n%s\n" "*******************compiling $(CURDIR)/$(@)*******************"
	$(MAKE) -C $@

tests: $(TARGET_SO) -lUtilities
	$(MAKE) -C $@

config_files:
	$(MAKE) -C ../ConfigFiles/$(NAME) $(filter clean_lib install,$(MAKECMDGOALS))

clean: $(CLEANDIRS) clean-tests remove

clean_lib:  config_files
	sudo rm -rf /usr/include/services/$(NAME)
	sudo rm -rf $(LIBS_DIR)/*lib$(NAME)*

remove:
	rm -f ./*.so.* ./*.so ./*.a.* ./*.a *.o $(includes)

install: config_files install_files

install_files:
ifdef SVOS
	install -d $(DESTDIR)/usr/include/services/$(NAME)/
	install -m 0444 inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/
	install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
else
	sudo mkdir -p /usr/include/services/$(NAME)/
	sudo cp inc/*.h /usr/include/services/$(NAME)/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
endif

$(CLEANDIRS) clean-tests: 
	$(MAKE) -C $(@:clean-%=%) clean
