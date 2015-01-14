NAME := ExecutionEngine


OBJECTS := $(patsubst %.cpp, %.o, $(wildcard src/*.cpp))

TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

targets_so := $(TARGET_SO)
$(TARGET_SO)_preq := -lUtilities

include ../preq.mk

DIRS := src 
CLEANDIRS := $(DIRS:%=clean-%) 
CLEANDIRS += clean-Tests

ifdef SVOS
DESTDIR ?= /
endif

EXT_LIBS :=  -lpcap -lc -lpci -lz -lboost_thread -lboost_filesystem -ldl 
ifdef SVOS
EXT_LIBS += -lrocket -lsv -lmrframe
endif
LIBS :=  $(EXT_LIBS)

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
FINAL_LIBS := $(LIBS) $(PVM_LIBS)

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY: Tests all clean $(DIRS) clean-Tests remove $(CLEANDIRS)
default: all

all: $(TARGET_SO) Tests

clean: $(CLEANDIRS) remove

Tests: $(TARGET_SO)
	$(MAKE) -C $@

remove:
	rm -f ./$(TARGET_SO) ./$(TARGET_SO).*


$(TARGET_SO): $(OBJECTS)
	$(CXX) -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)
	/sbin/ldconfig -n ./

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	@printf "\n%s\n" "*******************compiling $(CURDIR)/$(@)*******************"
	$(MAKE) -C $@

install: 
ifdef SVOS
	install -d $(DESTDIR)/usr/include/services/$(NAME)/
	install -m 0444 inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/
	install RegressionFileSchema.xsd $(DESTDIR)/usr/include/services/$(NAME)/
	install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
else
	sudo mkdir -p /usr/include/services/$(NAME)/
	sudo cp inc/*.h /usr/include/services/$(NAME)/
	sudo cp  RegressionFileSchema.xsd /usr/include/services/$(NAME)/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
endif

clean_lib: 
	sudo rm -rf /usr/include/services/$(NAME)
	sudo rm -rf $(LIBS_DIR)/*lib$(NAME)*

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
