NAME := ScapyPacketGenerator

python_version_full := $(wordlist 2,4,$(subst ., ,$(shell python --version 2>&1)))
python_version_major := $(word 1,${python_version_full})
python_version_minor := $(word 2,${python_version_full})
python_version_patch := $(word 3,${python_version_full})
python_lib := python${python_version_major}.${python_version_minor}

EXT_LIBS :=   -lpcap -lc -lpci -lz -lboost_system -ldl -l${python_lib}
PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS :=  $(EXT_LIBS) $(PVM_LIBS)
TARGET := lib$(NAME).so
TARGET_SO := lib$(NAME).so.0.0
targets :=  $(TARGET)
$(TARGET)_preq := -lPacketGeneratorI -lUtilities

include ../preq.mk

ifdef SVOS
DESTDIR ?= /
endif

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

DIRS := PythonServices ScapyFactory ScapyLayers ScapyPackets
srcfiles := $(foreach dirname,$(DIRS),$(wildcard $(dirname)/src/*.cpp))
OBJECTS := $(srcfiles:%.cpp=%.o)

CLEANDIRS := $(DIRS:%=clean-%)
CLEANLIB := $(DIRS:%=clean_lib-%)
INSTALLDIRS := $(DIRS:%=install-%)

.PHONY: default all $(DIRS) $(INSTALLDIRS) $(CLEANDIRS) Test clean_scapy install_scapy

default: all

ifdef SVOS
all: $(TARGET)
else
all: $(TARGET) install_scapy
endif
	$(MAKE) -C Test

$(TARGET): $(OBJECTS)
	$(CXX)   -shared -Wl,-soname,lib$(NAME).so -o ./$(TARGET_SO) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)
	/sbin/ldconfig -n ./

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	$(MAKE) -C $@/src

#On SVOS scapy is installed with its own debian package
install_scapy:
ifdef SVOS
	install -d $(DESTDIR)/opt
	cp -r ScapyCode $(DESTDIR)/opt/scapy-2.1.1
else
	cd ScapyCode/ ; pwd ; python setup.py build && sudo python setup.py install
endif

clean_scapy:
	rm -rf ScapyCode/build

ifndef SVOS
clean: $(CLEANDIRS) Test clean_scapy
else
#Since SVOS is not building with our modified scapy there is no need to clean it
clean: $(CLEANDIRS) Test
endif
	rm -f ./*.so* ./*.a* *.o

ifdef SVOS

install: $(INSTALLDIRS) install_scapy
	install ./$(TARGET_SO) $(DESTDIR)$(LIBS_DIR)

$(DESTDIR)/usr/include/services/$(NAME):
	install -d $@

$(INSTALLDIRS): | $(DESTDIR)/usr/include/services/$(NAME)
else

$(INSTALLDIRS): | /usr/include/services/$(NAME)
install: $(INSTALLDIRS)
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)

/usr/include/services/$(NAME):
	-sudo mkdir -p $@

endif

$(INSTALLDIRS):
	$(MAKE) -C $(@:install-%=%) install

clean_lib: 
	sudo rm -rf /usr/include/services/$(NAME) $(LIBS_DIR)/*lib$(NAME)*

$(CLEANDIRS) Test: 
	$(MAKE) -C $(@:clean-%=%) clean
