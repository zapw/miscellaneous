NAME := IosfFields

LIB_OBJS := CIosfFields.o
HFILES := CIosfFields.h

TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

targets_so := ../$(TARGET_SO)
../$(TARGET_SO)_preq := -lUtilities

set_inc := -lUtilities

INC_PVM := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
INC := -I../inc/ $(INC_PVM)
all_lib_inc := $(INC)

include  ../../preq.mk

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/  -L/usr/share/pvm3/lib/LINUXX86_64/  -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS :=  -ldl $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

ifdef SVOS
DESTDIR ?= /
endif

ifeq ($(shell uname -m), x86_64)
SHARE_LIBS_DIR := /usr/lib64
else
SHARE_LIBS_DIR := /usr/lib
endif

SHARE_INC_DIR := /usr/include/services

.PHONY: default all install clean ../../ConfigFiles/$(NAME) clean_lib_remove
default: all
	
all: ../$(TARGET_SO) ../$(TARGET_ST)
	
../$(TARGET_SO): $(LIB_OBJS)
	$(CXX) $(CPPFLAGS) $(INC) -shared -o ../$(TARGET_SO) $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)

../$(TARGET_ST): $(LIB_OBJS)
	ar -rcs ../$(TARGET_ST) $(LIB_OBJS)

install:
	@echo $(SHARE_LIBS_DIR)
ifdef SVOS
	install -d $(DESTDIR)$(SHARE_LIBS_DIR)/$(NAME)
	
	install ../$(TARGET_SO) $(DESTDIR)$(SHARE_LIBS_DIR)
	install ../$(TARGET_ST) $(DESTDIR)$(SHARE_LIBS_DIR)
	install -d $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
	install -m 0444 ../inc/*.h $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
else
	sudo mkdir -p $(SHARE_LIBS_DIR)/$(NAME)
	
	sudo cp ../$(TARGET_SO) $(SHARE_LIBS_DIR)
	sudo cp ../$(TARGET_ST) $(SHARE_LIBS_DIR)

	sudo /sbin/ldconfig -l $(SHARE_LIBS_DIR)/$(TARGET_SO)
		
	sudo mkdir -p $(SHARE_INC_DIR)/$(NAME)
	sudo cp ../inc/*.h $(SHARE_INC_DIR)/$(NAME)
endif
	$(MAKE) -C ../../ConfigFiles/$(NAME)

clean:
	rm -f *.o ../$(TARGET_ST) ../$(TARGET_SO) $(includes)

clean_lib: ../../ConfigFiles/$(NAME) clean_lib_remove

clean_lib_remove:
	sudo rm -rf $(SHARE_LIBS_DIR)/*lib$(NAME)* $(SHARE_INC_DIR)/$(NAME)

../../ConfigFiles/$(NAME):
	$(MAKE) -C $@ clean_lib

sources := $(LIB_OBJS:.o=.cpp)

$(eval $(auto_prerequisite_gen))
