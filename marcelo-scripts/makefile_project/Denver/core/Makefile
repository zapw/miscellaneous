include Core.mk

LIB_FILE := lib$(TARGET_NAME).so

sources := $(addprefix infrastructure/,src/*.cpp adapters/src/*.cpp SyntheticTest/src/*.cpp) executionEngine/src/*.cpp tests/src/*.cpp

ifdef SVOS
DESTDIR ?= /
sources += executionEngine/rocket/src/*.cpp
endif

objects := $(patsubst %.cpp,%.o,$(wildcard $(sources)))
dirs := $(sort $(dir $(sources)))
dirs_clean := $(patsubst %,%_clean,$(dirs)) bin_clean

.PHONY:  $(dirs) $(dirs_clean) default all bin remove_lib clean_lib clean install

default: all

$(objects): | $(dirs) ;

$(dirs):
	$(MAKE) -C $@

ifdef SVOS	
all: -l$(TARGET_NAME) bin
else
all: -l$(TARGET_NAME) bin install
endif

bin: -l$(TARGET_NAME)
	$(MAKE) -C $@

-l$(TARGET_NAME): $(objects)
	$(CXX) $(ROOT_GLOBAL_LIBS) -shared -Wl,-soname,$(LIB_FILE) -o ./$(TARGET_SO) $(objects) 
	/sbin/ldconfig -n ./

clean: $(dirs_clean) remove_lib
remove_lib:
	rm -f $(LIB_FILE) $(TARGET_SO)

$(dirs_clean):
	$(MAKE) -C $(@:%_clean=%) clean	

ifdef SVOS
install: $(LIB_FILE)
	install -d $(DESTDIR)/usr/include/Denver/Infrastructure/
	install infrastructure/inc/*.xsd $(DESTDIR)/usr/include/Denver/Infrastructure/
	$(MAKE) -C bin install
	install -d $(DESTDIR)/usr/lib64/
	install $(LIB_FILE) $(DESTDIR)/usr/lib64/
else
install:
	sudo mkdir -p /usr/include/Denver/ /usr/include/Denver/Infrastructure/
	sudo cp infrastructure/inc/*.xsd /usr/include/Denver/Infrastructure/
endif

clean_lib:
	sudo rm -rf /usr/include/Denver/ /usr/include/Denver/Infrastructure/ /usr/include/Denver/ExecutionEngine/
ifdef SVOS
.PHONY: lib_file bin_cleanlib
clean_lib: lib_file bin_cleanlib
lib_file:
	sudo rm -f $(DESTDIR)/usr/lib64/$(LIB_FILE)
bin_cleanlib:
	$(MAKE) -C bin clean_lib
endif
