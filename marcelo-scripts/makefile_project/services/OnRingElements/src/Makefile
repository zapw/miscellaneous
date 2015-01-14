NAME := OnRingElements
TCLNAME := PcktDescDB

LIB_OBJS := 	CPcktDescDB.o\
		CElementOnRing.o\
		CDescriptorOnRing.o\
		CPacketOnRing.o\
		CRing.o		

HFILES := 	CPcktDescDB.h\
		CElementOnRing.h\
		CDescriptorOnRing.h\
		CPacketOnRing.h\
		CRing.h

TARGET_SO := ../lib$(NAME).so
TARGET_ST := ../lib$(NAME).a

TCL_TARGET_SO := ../lib$(TCLNAME)Tcl.so

targets_so := $(TARGET_SO) $(TCL_TARGET_SO)
$(TARGET_SO)_preq := -lUtilities -lDescriptorFields
$(TCL_TARGET_SO)_preq := -lUtilities -lDescriptorFields
set_inc := -lUtilities -lDescriptorFields

INC_PVM := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
INC := -I/usr/include/tcl8.5 $(INC_PVM) -I../inc
all_lib_inc := $(INC)

include ../../preq.mk

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -L/usr/local/lib/ -lpvm3 -lgpvm3
LIBS := -lpcap -ldl $(PVM_LIBS)
DBG := -g
FLAGS := -fPIC -Wall
CXXFLAGS := $(FLAGS) $(DBG)

SWIG_LIBS := $(LIBS) -L../ -l$(NAME)
SWIGFLAGS := -w378,401,503

ifeq ($(shell uname -m), x86_64)
SHARE_LIBS_DIR := /usr/lib64
else
SHARE_LIBS_DIR := /usr/lib
endif

SHARE_INC_DIR := /usr/include/services

ifndef SVOS
SUDO=sudo
endif

.PHONY: default all

default: all

all: $(TCL_TARGET_SO) $(TARGET_SO) $(TARGET_ST)
	
$(TCL_TARGET_SO): $(TARGET_SO) $(TCLNAME)_wrap.o
	$(CXX)  -shared -o $(TCL_TARGET_SO) $(TCLNAME)_wrap.o $(LDFLAGS) $(LDLIBS) $(SWIG_LIBS)
	
$(TARGET_SO): $(LIB_OBJS)
	$(CXX) -shared -o $(TARGET_SO) $(LIB_OBJS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(TCLNAME)_wrap.o: ../TCL/$(TCLNAME)_wrap.cxx
	$(CXX) $(FLAGS) -c $(all_lib_inc) ../TCL/$(TCLNAME)_wrap.cxx
	
../TCL/$(TCLNAME)_wrap.cxx: ../TCL/$(TCLNAME).i
	swig -tcl -c++  -namespace -prefix $(TCLNAME) $(all_lib_inc) $(SWIGFLAGS) ../TCL/$(TCLNAME).i

../TCL/$(TCLNAME).i: ;
	
$(TARGET_ST): $(LIB_OBJS)
	ar -rcs $(TARGET_ST) $(LIB_OBJS)

install:
	@echo $(SHARE_LIBS_DIR)
ifdef SVOS
	install -d $(DESTDIR)$(SHARE_LIBS_DIR)/$(NAME)

	install $(TARGET_SO) $(DESTDIR)$(SHARE_LIBS_DIR)
	install $(TARGET_ST) $(DESTDIR)$(SHARE_LIBS_DIR)
	install $(TCL_TARGET_SO) $(DESTDIR)$(SHARE_LIBS_DIR)


	install ../TCL/$(TCLNAME).tcl $(DESTDIR)$(SHARE_LIBS_DIR)/$(TCLNAME)
	install ../TCL/pkgIndex.tcl $(DESTDIR)$(SHARE_LIBS_DIR)/$(TCLNAME)
	install -d $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
	install -m 0444 ../inc/*.h $(DESTDIR)$(SHARE_INC_DIR)/$(NAME)
else
	sudo mkdir -p $(SHARE_LIBS_DIR)/$(NAME)

	sudo cp $(TARGET_SO) $(SHARE_LIBS_DIR)
	sudo cp $(TARGET_ST) $(SHARE_LIBS_DIR)

	sudo /sbin/ldconfig -l $(SHARE_LIBS_DIR)/lib$(NAME).so
	sudo cp $(TCL_TARGET_SO) $(SHARE_LIBS_DIR)
	sudo /sbin/ldconfig -l $(SHARE_LIBS_DIR)/lib$(TCLNAME)Tcl.so

	sudo cp ../TCL/$(TCLNAME).tcl $(SHARE_LIBS_DIR)/$(TCLNAME)
	sudo cp ../TCL/pkgIndex.tcl $(SHARE_LIBS_DIR)/$(TCLNAME)
	sudo mkdir -p $(SHARE_INC_DIR)/$(NAME)
	sudo cp ../inc/*.h $(SHARE_INC_DIR)/$(NAME)
endif

clean:
	rm -f *.so* *.a  *.o ../*.so* ../*.a $(includes)

clean_lib:
	sudo rm -rf $(SHARE_LIBS_DIR)/*lib$(NAME)* $(SHARE_LIBS_DIR)/*lib$(TCLNAME)Tcl* $(SHARE_INC_DIR)/$(NAME)


sources := $(LIB_OBJS:.o=.cpp)

$(eval $(auto_prerequisite_gen))
