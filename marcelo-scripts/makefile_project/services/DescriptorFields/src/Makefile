NAME := DescriptorFields
DIR_NAME := descriptors

LIB_OBJS := CDescriptorFields.o

HFILES := CDescriptorFields.h

ifdef SVOS
DESTDIR ?= /
endif

LIBS := -ldl

DBG := -g
FLAGS := -fPIC -Wall
TARGET_SO := lib$(NAME).so
TARGET_ST := lib$(NAME).a

TCL_TARGET_SO := lib$(NAME)Tcl.so
SWIG_LIBS := $(LIBS)
SWIGFLAGS := -w378,401,503 

ifeq ($(shell uname -m), x86_64)
SHARE_LIBS_DIR := /usr/lib64
else
SHARE_LIBS_DIR := /usr/lib
endif

SHARE_INC_DIR := /usr/include/services

targets_so := ../$(TCL_TARGET_SO) ../$(TARGET_SO)
set_inc := -lUtilities
INC := -I../inc/ -I/usr/include/tcl8.5
all_lib_inc := $(INC)

../$(TCL_TARGET_SO)_preq := -lUtilities -lDescriptorFields

../$(TARGET_SO)_preq := -lUtilities

include ../../preq.mk
CXXFLAGS := $(DBG) $(FLAGS)

.PHONY: default all lib clib compile_swig stlib
default: all

all: lib clib stlib

../$(TCL_TARGET_SO): $(NAME)_wrap.o ../$(TARGET_SO)
	$(CXX) $(CPPFLAGS) $(INC) -shared -o ../$(TCL_TARGET_SO) $(NAME)_wrap.o $(LDFLAGS) $(LDLIBS) $(SWIG_LIBS)
lib: ../$(TCL_TARGET_SO)

../$(TARGET_SO): $(LIB_OBJS)
	$(CXX) $(CPPFLAGS) $(INC) -shared -o ../$(TARGET_SO) $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)
clib: ../$(TARGET_SO)

../$(TARGET_ST): $(LIB_OBJS)
	ar -rcs ../$(TARGET_ST) $(LIB_OBJS)
stlib: ../$(TARGET_ST)

$(NAME)_wrap.o: ../TCL/$(NAME)_wrap.cxx
	$(CXX) $(FLAGS) -c $(INC) $(lib_inc) ../TCL/$(NAME)_wrap.cxx

../TCL/$(NAME)_wrap.cxx: ../TCL/$(NAME).i
	swig -tcl -c++ -namespace -prefix $(NAME) $(INC) $(lib_inc) $(SWIGFLAGS) ../TCL/$(NAME).i

compile_swig: ../TCL/$(NAME)_wrap.cxx

../TCL/$(NAME).i: ;

install:
	@echo $(SHARE_LIBS_DIR)
ifdef SVOS
	install -d $(DESTDIR)$(SHARE_LIBS_DIR)/$(NAME)
	install ../$(TARGET_SO) $(DESTDIR)$(SHARE_LIBS_DIR)
	install ../$(TARGET_ST) $(DESTDIR)$(SHARE_LIBS_DIR)
	install ../$(TCL_TARGET_SO) $(DESTDIR)$(SHARE_LIBS_DIR)
	install ../TCL/$(NAME).tcl $(DESTDIR)$(SHARE_LIBS_DIR)/$(NAME)
	install ../TCL/pkgIndex.tcl $(DESTDIR)$(SHARE_LIBS_DIR)/$(NAME)
	install -d $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
	install -m 0444 ../inc/*.h $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
else
	@echo $(SHARE_LIBS_DIR)
	sudo mkdir -p $(SHARE_LIBS_DIR)/$(NAME)
	
	sudo cp ../$(TARGET_SO) $(SHARE_LIBS_DIR)
	sudo cp ../$(TARGET_ST) $(SHARE_LIBS_DIR)

	sudo /sbin/ldconfig -l $(SHARE_LIBS_DIR)/$(TARGET_SO)
	sudo cp ../$(TCL_TARGET_SO) $(SHARE_LIBS_DIR)
	sudo /sbin/ldconfig -l $(SHARE_LIBS_DIR)/$(TCL_TARGET_SO)

	sudo cp ../TCL/$(NAME).tcl $(SHARE_LIBS_DIR)/$(NAME)
	sudo cp ../TCL/pkgIndex.tcl $(SHARE_LIBS_DIR)/$(NAME)
	
	sudo mkdir -p $(SHARE_INC_DIR)/$(NAME)
	sudo cp ../inc/*.h $(SHARE_INC_DIR)/$(NAME)
	
endif
	$(MAKE) -C ../../ConfigFiles/$(NAME)

clean:
	rm -f *.so* *.a  *.o $(includes) ../*.so* ../*.a

ifneq '$(SHARE_INC_DIR)' ''
        ifneq '$(NAME)' ''
              safe_delete := $(SHARE_INC_DIR)/$(NAME)
        endif
endif

clean_lib:
	sudo rm -rf $(SHARE_LIBS_DIR)/*lib$(NAME)* $(safe_delete)
	$(MAKE) -C ../../ConfigFiles/$(NAME) $@

sources = $(wildcard *.cpp) ../TCL/$(NAME)_wrap.cxx

$(eval $(auto_prerequisite_gen))
