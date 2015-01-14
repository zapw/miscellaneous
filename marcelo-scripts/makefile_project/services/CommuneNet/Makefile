NAME := CommuneNet

TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

targets := $(NAME) 
targets_so := $(TARGET_SO)


$(NAME)_preq := -lUtilities
$(TARGET_SO)_preq := -lUtilities

include ../preq.mk

OBJECTS := $(patsubst %.cpp,%.o,$(wildcard src/*.cpp))

DIRS := src 
CLEANDIRS := $(DIRS:%=clean-%) 
CLEANDIRS += clean-client clean-tests

ifdef SVOS
DESTDIR ?= /
endif

EXT_LIBS :=  -lpcap -lc -lpci -lz -lboost_thread -lboost_filesystem -ldl -lpthread -lrt
LIBS := $(EXT_LIBS) -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/  -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3 

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY: default all client/tests $(DIRS) $(CLEANDIRS) remove

default: all

all: $(TARGET_SO) $(NAME) client/tests tests #$(TARGET_ST)


$(NAME): $(OBJECTS)
	$(CXX) $(CPPFLAGS) -o ./$(NAME) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(TARGET_SO): $(OBJECTS)
	$(CXX) -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	/sbin/ldconfig -n ./

$(TARGET_ST): $(OBJECTS)
	ar -rcs ./$(TARGET_ST) $(OBJECTS)

client/tests tests: -lUtilities
	$(MAKE) -C $@

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	$(MAKE) -C $@

clean: $(CLEANDIRS) remove
remove:
	rm -f $(NAME) $(TARGET_SO) $(TARGET_SO).* $(TARGET_ST)

install: 
ifdef SVOS
	$(SUDO) install -d $(DESTDIR)/usr/include/services/$(NAME)/
	$(SUDO) install -d $(DESTDIR)/usr/include/services/$(NAME)/app/cfg/
	$(SUDO) install -m 0444 inc/*.h $(DESTDIR)/usr/include/services/$(NAME)/
	$(SUDO) install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)
else
	sudo mkdir -p /usr/include/services/$(NAME)/
	sudo mkdir -p /usr/include/services/$(NAME)/app/cfg/
	sudo cp inc/*.h /usr/include/services/$(NAME)/
	#sudo cp app/cfg/ClientFileSchema.xsd  /usr/include/services/$(NAME)/app/cfg/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
	#make -C app install
endif

clean_lib: 
	sudo rm -rf /usr/include/services/$(NAME)
	sudo rm -rf $(LIBS_DIR)/*lib$(NAME)*

$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
