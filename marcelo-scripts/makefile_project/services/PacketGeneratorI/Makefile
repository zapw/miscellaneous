NAME := PacketGeneratorI

TARGET := lib$(NAME).so
TARGET_SO := lib$(NAME).so.0.0

targets := $(TARGET)
targets_preq := -lUtilities -lRegisterFields

include  ../preq.mk
EXT_LIBS :=   -lpcap -lc -lpci -lz -lboost_system -ldl
PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS :=  $(EXT_LIBS) $(PVM_LIBS)

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

ifdef SVOS
DESTDIR ?= /
endif

DIRS := IFactory  ILayers  IPackets Payload  Utilities
srcfiles := $(foreach dirname,$(DIRS),$(wildcard $(dirname)/src/*.cpp))
OBJECTS := $(srcfiles:%.cpp=%.o)

CLEANDIRS := $(DIRS:%=clean-%)
CLEANDIRS += clean-tests
CLEANLIB := $(DIRS:%=clean_lib-%)
INSTALLDIRS := $(DIRS:%=install-%)

.PHONY: default all $(DIRS) $(INSTALLDIRS) $(CLEANDIRS) tests remove

default: all
all: $(TARGET) tests

tests: $(TARGET)
	$(MAKE) -C $@

$(TARGET): $(OBJECTS)
	$(CXX) -shared -Wl,-soname,lib$(NAME).so -o ./$(TARGET_SO) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	/sbin/ldconfig -n ./

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	$(MAKE) -C $@/src

clean:	$(CLEANDIRS) remove
remove:
	rm -f ./*.so* ./*.a*

install: $(INSTALLDIRS) 
ifdef SVOS
	install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)

$(DESTDIR)/usr/include/services/$(NAME):
	install -d $@ 

$(INSTALLDIRS): | $(DESTDIR)/usr/include/services/$(NAME)
else
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)

/usr/include/services/$(NAME):
	-sudo mkdir -p $@

$(INSTALLDIRS): | /usr/include/services/$(NAME)
endif

$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) install

clean_lib:
	sudo rm -rf /usr/include/services/$(NAME) $(LIBS_DIR)/*lib$(NAME)*

$(CLEANDIRS):
	$(MAKE) -C $(@:clean-%=%) clean
