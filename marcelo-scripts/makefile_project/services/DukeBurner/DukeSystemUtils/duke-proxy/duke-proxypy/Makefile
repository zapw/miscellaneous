PROG=dukeproxypy
CC=g++
CFLAGS=-Wall -g -fpic -rdynamic -shared  
MAIN_PROG=dukepy.py
DUKE_PROXY_DIR:=../duke-proxy
LIBDIR=$(DUKE_PROXY_DIR)/lib
CPPDIR=../duke-proxycpp
LIBS=-L $(LIBDIR) -lduke
SWIG_INC = -I$(DUKE_PROXY_DIR)/inc -I$(CPPDIR)
TARGET_DIR=target
TARGET=$(TARGET_DIR)/_$(PROG).so
SWIG_FLAGS=-python -c++ -outdir $(TARGET_DIR)
PY_VERSION=$(shell python -c "import sys;print '.'.join((str(sys.version_info.major), str(sys.version_info.minor)))")
PY_INSTALL_PATH=$(shell python -c "import site; print site.getsitepackages()[0]")
INC=-I/usr/include/python$(PY_VERSION) $(SWIG_INC)

vpath %.so ../duke-proxy/lib

$(TARGET):  libduke.so Duke.o $(PROG)_wrap.o | $(TARGET_DIR)
	$(CC) -o $(TARGET) $(CFLAGS) $(PROG)_wrap.o Duke.o -Wl,-rpath=$(LIBDIR) $(LIBS)
	cp $(MAIN_PROG) $(TARGET_DIR)
	chmod u+w $(TARGET)

Duke.o: $(CPPDIR)/Duke.cpp $(CPPDIR)/Duke.h
	$(CC) -fpic $(INC) -c $(CPPDIR)/Duke.cpp

libduke.so:
	$(MAKE) -C ../duke-proxy

$(PROG)_wrap.o: $(PROG)_wrap.cxx
	$(CC) -fpic -c $(PROG)_wrap.cxx $(INC)

$(PROG)_wrap.cxx: $(PROG).i
	swig $(SWIG_FLAGS) $(SWIG_INC) $(PROG).i

$(PROG).i: ;

$(TARGET_DIR):
	-mkdir -p $@

install:
	mkdir -p $(DESTDIR)$(PY_INSTALL_PATH)
	sudo cp $(TARGET_DIR)/_$(PROG).so $(TARGET_DIR)/$(PROG).py $(TARGET_DIR)/dukepy.py $(DESTDIR)$(PY_INSTALL_PATH)

uninstall:
	sudo rm -f $(PY_INSTALL_PATH)/_$(PROG).so $(PY_INSTALL_PATH)/$(PROG).py $(PY_INSTALL_PATH)/dukepy.py   

clean:
	rm -rf *.o *.cxx $(PROG).py *.pyc $(TARGET_DIR)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
