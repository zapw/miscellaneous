###############################################################
#                                                             #
#  Makefile for SVScript
#                                                             #
###############################################################

.DELETE_ON_ERROR:
USE_NEVADA = 0

OS_NAME := $(shell cat /etc/redhat-release | cut -d " " -f1)

ifeq ($(USE_NEVADA),1)
	DEFINES = \
		-DUSE_NEVADA \
		-DSVSCRIPT

	INCLUDES_NEVADA = \
		-I../../../../application/agent/inc\
		-I../../../../application/common/inc
	
	AGENTDIR = ../../../../application/agent/src
	COMMONDIR = ../../../../application/common/src
	
	SOURCES_NEVADA = \
			../../common/SvdtPackets.cpp \
			$(AGENTDIR)/CPacket.cpp \
			$(AGENTDIR)/CTxPacket.cpp \
			$(AGENTDIR)/CTxPacketsDB.cpp \
			$(AGENTDIR)/CTxRingsParser.cpp \
			$(COMMONDIR)/CRootDir.cpp \
			$(COMMONDIR)/CGenericParser.cpp \
			$(COMMONDIR)/UtilFuncs.cpp \
			$(COMMONDIR)/CDOMTreeErrorReporter.cpp
	
	LIBS_NEVADA = -lxerces-c
endif

INCLUDES = \
	-I../../../api/inc\
	-I../inc\
	-I../../../api/iwarp/inc\
	-I../../../nes/shared\
	-I../../common\
	-I../../svdt\
	-I../../../liteignite/inc\
	-I../../../jtagAccess/inc\
	-I../../../pci/api/inc\
	-I../../../../services/FpgaAccess/FpgaAccessApi\
	-I/usr/include/sv_driver/api\
	-I/usr/include/fpga_access\
	$(INCLUDES_NEVADA)

LIBDIRS = -L../../../api/lib\
	-L/usr/local/lib\
	-L../../../liteignite/src\
	-L../../../pci/api/src\
	-L../../../../services/FpgaAccess/FpgaAccessApi

ifeq ($(OS_NAME),Red) #redhat
    CPPFLAGS =$(INCLUDES) $(DEFINES) $(GENERAL_DEFINES) -DNO_LITEIGNITE -Wall -fpic
    ifeq ($(shell uname -m),i686)
	LIBS = -lDriverApi -lDriverIwarpApi -lboost_system -lPciApi -ldl -lpci -lz $(LIBS_NEVADA)
    else
	LIBS = -lDriverApi -lDriverIwarpApi -lboost_system -lPciApi -lJtagAccess -ldl -lpci -lz $(LIBS_NEVADA)
    endif
else
    CPPFLAGS =$(INCLUDES) $(DEFINES) $(GENERAL_DEFINES) -Wall -fpic
    ifeq ($(shell uname -m),i686)
	LIBS = -lDriverApi -lDriverIwarpApi -lboost_system -lPciApi -ldl -lpci -lz $(LIBS_NEVADA)
    else
	LIBS = -lDriverApi -lDriverIwarpApi -lboost_system -lPciApi -lJtagAccess -ldl -lpci -lz $(LIBS_NEVADA)
    endif
endif


ifeq ($(NO_SERVICES),1)
CPPFLAGS +=-DNO_LITEIGNITE
else
LIBS += -lFpgaRegisterAccessApi
endif

#CPPFLAGS =$(INCLUDES) $(DEFINES) $(GENERAL_DEFINES) -Wall -fpic
SWIGFLAGS=$(INCLUDES) $(DEFINES) -Wall


ifeq ($(shell cat /etc/redhat-release), Laughlin)
@echo UUUUU
endif

#SOURCES = \
#	../../common/SvdtLib.cpp\
#	../../common/SvdtPacketCollectorPcap.cpp\
#	$(SOURCES_NEVADA)

#OBJECTS = $(SOURCES:.cpp=.o)  # expands to list of object files

LDFLAGS = -rdynamic $(LIBDIRS) $(LIBS)

TCL_TARGET_SO = libSvTcl.so
PYTHON_TARGET_SO = _libSvPython.so

python_version_full := $(wordlist 2,4,$(subst ., ,$(shell python --version 2>&1)))
python_version_major := $(word 1,${python_version_full})
python_version_minor := $(word 2,${python_version_full})
python_version_patch := $(word 3,${python_version_full})

my_cmd.python.2 := python2 some_script.py2
my_cmd.python.3 := python3 some_script.py3
python_ver := python${python_version_major}.${python_version_minor}



#PYTHON_TARGET_SO = _svscript.so
PYTHON_LIB = $(python_ver)


ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
CPPFLAGS += -DX86_64
DEFINES += -DX86_64
else
LIBS_DIR = /usr/lib
endif


PYTHON_INC = \
	-I/usr/include/python2.6/\
	-I/usr/include/python2.7/

.PHONY: tcl python all install clean

all: $(TCL_TARGET_SO) $(PYTHON_TARGET_SO)

python: $(PYTHON_TARGET_SO)
tcl: $(TCL_TARGET_SO)

install: install_tcl install_python

vpath %.so ../../../api/lib ../../../pci/api/src ../../../../services/FpgaAccess/FpgaAccessApi

RCF_OBJ=../../../remoting/Rcf/RCF.o

libDriverIwarpApi.so: $(RCF_OBJ)
	$(MAKE) -C ../../../api/iwarp lib

libDriverApi.so: $(RCF_OBJ)
	$(MAKE) -C ../../../api/src lib

libPciApi.so:
	$(MAKE) -C ../../../pci/api/src

libFpgaRegisterAccessApi.so:
	$(MAKE) -C ../../../../services/FpgaAccess/FpgaAccessApi $@

$(RCF_OBJ):
	$(MAKE) -C ../../../remoting RCF


$(TCL_TARGET_SO): libDriverIwarpApi.so libDriverApi.so libPciApi.so libFpgaRegisterAccessApi.so svScript_wrap_tcl.o svScript.o
	$(CXX) -shared -o $(TCL_TARGET_SO) svScript.o svScript_wrap_tcl.o $(CPPFLAGS) $(LDFLAGS)
	
$(PYTHON_TARGET_SO): libDriverIwarpApi.so libDriverApi.so libPciApi.so libFpgaRegisterAccessApi.so svScript_wrap_python.o svScript.o
	@echo hhh $KKK
	$(CXX) -shared -o $(PYTHON_TARGET_SO) svScript.o svScript_wrap_python.o $(CPPFLAGS) $(LDFLAGS)

svScript_wrap_tcl.o: svScript_wrap_tcl.cxx
	$(CXX) -fpic -c svScript_wrap_tcl.cxx $(CPPFLAGS)

svScript_wrap_python.o: svScript_wrap_python.cxx
	$(CXX) -fpic -c svScript_wrap_python.cxx $(PYTHON_INC) -I$(LIBS_DIR)/$(PYTHON_LIB)/config/ $(CPPFLAGS)

svScript_wrap_python.cxx: svScript.i svScript.cxx
	swig -python -c++ $(SWIGFLAGS) -DPYTHON  -o svScript_wrap_python.cxx svScript.i

svScript_wrap_tcl.cxx: svScript.i svScript.cxx
	swig -tcl -namespace -prefix svtcl -c++ $(SWIGFLAGS) -DSVTCL -o svScript_wrap_tcl.cxx svScript.i

svScript.o: svScript.cxx
	$(CXX) -fpic -c svScript.cxx $(CPPFLAGS)

svScript.i svScript.cxx: ;


install_tcl:
	@echo $(LIBS_DIR)
	sudo cp $(TCL_TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TCL_TARGET_SO)
	sudo cp ../run_svtcl /usr/bin
	sudo cp ../svtcllib.tcl /usr/share

install_python:
	@echo $(LIBS_DIR)
	sudo cp *.py $(LIBS_DIR)/$(PYTHON_LIB)
	sudo cp $(PYTHON_TARGET_SO) $(LIBS_DIR)/$(PYTHON_LIB)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(PYTHON_LIB)/$(PYTHON_TARGET_SO)

print_ver:
	@echo '$(python_ver)'


sources = svScript_wrap_python.cxx svScript_wrap_tcl.cxx svScript.cxx

ifdef SOURCES_NEVADA
sources += $(SOURCES_NEVADA)
endif

clean:
	rm -f $(OBJECTS) *.o *.so svScript_wrap_python.cxx svScript_wrap_tcl.cxx $(includes) *.py

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F)) svScript.cxx
	$(CXX) -D SWIG_PYTHON_CLASSIC=1 $(INCLUDES) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
