NAME := RegisterFields

#Target files
TARGET_SO:=lib$(NAME).so
TARGET_ST:=lib$(NAME).a
TCL_TARGET_SO:=lib$(NAME)Tcl.so

ifeq ($(shell uname -m), x86_64)
        LIBS_DIR := /usr/lib64
else
        LIBS_DIR := /usr/lib
endif

ifeq ($(SVOS),1)
 DESTDIR ?= /
 TCL_DIR := /usr/include/tcl8.5
else
 sudo := sudo
 TCL_DIR := $(LIBS_DIR)/tcl8.5
endif

OBJECTS = $(patsubst %.cpp, %.o, $(wildcard *.cpp))
targets_so := -lRegisterFields ../$(TCL_TARGET_SO) 
../$(TCL_TARGET_SO)_preq := -lRegisterFields -lUtilities
-lRegisterFields_preq := -lUtilities

set_inc := -lRegisterFields
LDLIBS := -ldl

all_lib_inc := -I$(TCL_DIR)
include ../../preq.mk
SWIG_FLAGS := -w378,401,503
CXXFLAGS := -fPIC -Wall -g

.PHONY: default all clean clean_lib clean_lib_configfiles remove_files
default: all

all: -lRegisterFields ../$(TCL_TARGET_SO) ../$(TARGET_ST)

../$(TCL_TARGET_SO): -lRegisterFields $(NAME)_wrap.o
	$(CXX) -shared -o ../$(TCL_TARGET_SO) $(NAME)_wrap.o $(LDFLAGS) $(LDLIBS)

-lRegisterFields: $(OBJECTS)
	$(CXX) -shared -o ../$(TARGET_SO) $(OBJECTS) $(LDFLAGS) $(LDLIBS)

../$(TARGET_ST): $(OBJECTS)
	ar -rcs ../$(TARGET_ST) $(OBJECTS)

$(NAME)_wrap.o: ../TCL/$(NAME)_wrap.cxx
	$(CXX) $(CXXFLAGS) $(all_lib_inc) -c ../TCL/$(NAME)_wrap.cxx

../TCL/$(NAME)_wrap.cxx: ../TCL/$(NAME).i
	swig -tcl -c++ -namespace -prefix $(NAME) $(all_lib_inc) $(SWIG_FLAGS) ../TCL/$(NAME).i

../TCL/$(NAME).i: ;

clean:
	rm -f ../*.so.* ../*.so ../*.a.* ../*.a *.o $(includes) ../TCL/$(NAME)_wrap.cxx
	
clean_lib: clean_lib_configfiles remove_files

remove_files:
	$(sudo) rm -rf $(LIBS_DIR)/*lib$(NAME)* /usr/include/services/$(NAME)

clean_lib_configfiles:
	$(MAKE) -C ../../ConfigFiles/$(NAME) clean_lib

install: ;

sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
