NAME := Ixia


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

EXT_LIBS := -lpcap -lc -lpci -lz -lboost_thread -lboost_filesystem -ldl 
LIBS :=  $(EXT_LIBS)

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
FINAL_LIBS := $(LIBS) $(PVM_LIBS)

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY: default all clean Tests remove $(DIRS) $(CLEANDIRS)
default: all

all: $(TARGET_SO) Tests #$(TARGET_ST)

$(TARGET_SO): $(OBJECTS)
	$(CXX)  -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)
	/sbin/ldconfig -n ./

$(TARGET_ST): $(OBJECTS)
	ar -rcs ./$(TARGET_ST) $(OBJECTS)

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	@printf "\n%s\n" "*******************compiling $(CURDIR)/$(@)*******************"
	$(MAKE) -C $@

Tests: $(TARGET_SO) -lUtilities
	$(MAKE) -C $@

install: 
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

clean_lib: 
	sudo rm -rf /usr/include/services/$(NAME) $(LIBS_DIR)/*lib$(NAME)*

clean: $(CLEANDIRS) remove

remove:
	rm -f ./*.so* ./*.a* *.o $(includes)


$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
