NAME := gUtilities

EXEC_NAME := BufferFields

TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

targets := $(EXEC_NAME)
targets_so := $(TARGET_SO)
targets_preq := -lUtilities
targets_so_preq := -lUtilities

include ../preq.mk

OBJECTS := $(patsubst %.cpp, %.o, $(wildcard src/*.cpp))

DIRS := src 
CLEANDIRS := $(DIRS:%=clean-%) 

EXT_LIBS := -lpcap -lc -lpci -lz -lboost_thread -lboost_filesystem -ldl 
LIBS := $(EXT_LIBS) $(shell wx-config --libs)

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
FINAL_LIBS := $(LIBS) $(PVM_LIBS)


ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY: default all $(DIRS) $(CLEANDIRS) remove

default: all
all: $(TARGET_SO) $(TARGET_ST) $(EXEC_NAME)

$(TARGET_SO): $(OBJECTS)
	$(CXX)  -shared -Wl,-soname,$(TARGET_SO) -o ./$(TARGET_SO).0.0 $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)
	/sbin/ldconfig -n ./

$(EXEC_NAME): $(OBJECTS)
	$(CXX) $(CPPFLAGS)  -o $(EXEC_NAME) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

$(TARGET_ST): $(OBJECTS)
	ar -rcs ./$(TARGET_ST) $(OBJECTS)

$(OBJECTS): | $(DIRS) ;
$(DIRS): 
	@printf "\n%s\n" "*******************compiling $(CURDIR)/$(@)*******************"
	$(MAKE) -C $@

install: 
	sudo mkdir -p /usr/include/services/$(NAME)/
	sudo cp inc/*.h /usr/include/services/$(NAME)/
	sudo cp ./$(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)


clean_lib: 
	sudo rm -rf /usr/include/services/$(NAME) $(LIBS_DIR)/*lib$(NAME)*

clean: $(CLEANDIRS) remove

remove:
	rm -f ./*.so* ./*.a* $(EXEC_NAME)


$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
