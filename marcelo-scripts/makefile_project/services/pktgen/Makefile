objects := $(patsubst %.cpp,%.o,$(wildcard pktgen_lib/src/*.cpp))

ifdef SVOS
DESTDIR ?= /
endif

ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif

INC_DIR = /usr/include/services/pktgen/
INC_DIR_LOCAL = pktgen_lib/inc/

all_lib_inc := -I$(INC_DIR_LOCAL)
include ../preq.mk

CXXFLAGS = -fPIC -Wall $(all_lib_inc)

.PHONY: default all pktgen_test clean-pktgen_test remove
default: all

all: bin/libpktgen.so bin/libpktgen.a pktgen_test

bin/libpktgen.so: $(objects)
	$(CXX) -shared -o $@ $(objects)

bin/libpktgen.a: $(objects)
	ar rcs $@ $(objects)

pktgen_test: bin/libpktgen.so
	$(MAKE) -C $@

install:
ifdef SVOS
	install -d $(DESTDIR)$(INC_DIR)
	install ./pktgen_lib/inc/*.h $(DESTDIR)$(INC_DIR)
	install bin/libpktgen.so $(DESTDIR)$(LIBS_DIR)
	install bin/libpktgen.a $(DESTDIR)$(LIBS_DIR)
else
	sudo mkdir -p $(INC_DIR)
	sudo cp ./pktgen_lib/inc/*.h $(INC_DIR)
	sudo cp bin/libpktgen.so $(LIBS_DIR)
	sudo cp bin/libpktgen.a $(LIBS_DIR)
	sudo ldconfig
endif

clean_lib:
	sudo rm -rf $(LIBS_DIR)/libpktgen.so $(LIBS_DIR)/libpktgen.a $(INC_DIR)

clean: clean-pktgen_test remove

remove:
	rm -f $(objects) bin/libpktgen.a bin/libpktgen.so bin/pktgen_test $(includes)

clean-pktgen_test:
	$(MAKE) -C $(@:clean-%=%) clean

sources := $(objects:.o=.cpp)

$(eval $(auto_prerequisite_gen))
