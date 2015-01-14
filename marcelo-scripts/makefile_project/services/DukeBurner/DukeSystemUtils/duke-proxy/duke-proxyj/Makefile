PROG=dukeproxyj
CC=g++
CFLAGS=-Wall -g -fpic -rdynamic -shared  
DUKE_PROXY_DIR=../duke-proxy
DUKE_LIB_DIR=$(DUKE_PROXY_DIR)/lib
LIBS=-L$(DUKE_LIB_DIR) -lduke
CPPDIR=../duke-proxycpp
JAVA_PROJ:=duke-proxy
JAVA_ODIR:=$(JAVA_PROJ)/src/main/java/com/intel/duke/proxy
INST_DIR=duke-porxyj
SWIG_INC = -I$(DUKE_PROXY_DIR)/inc -I$(CPPDIR)
INC=$(SWIG_INC) 
SWIG_FLAGS:=-java -c++ -package com.intel.duke.proxy -outdir $(JAVA_ODIR)
TARGET_DIR=target
TARGET=$(TARGET_DIR)/lib$(PROG).so
JAVA_INC:=-I$(shell dirname $(shell locate jni.h | head -1))
JAVA_INC:=$(JAVA_INC) $(JAVA_INC)/linux $(INC)
GLOBAL_LIB_DIR=/usr/lib64/

vpath %.so ../duke-proxy/lib
vpath %.java $(JAVA_ODIR)

$(TARGET):  libduke.so Duke.o $(PROG)_wrap.o $(JAVA_PROJ)/build/libs/duke-proxy.jar | $(TARGET_DIR)
	$(CC) -o $(TARGET) $(CFLAGS) $(PROG)_wrap.o Duke.o -Wl,-rpath=$(DUKE_LIB_DIR) $(LIBS)

Duke.o: $(CPPDIR)/Duke.cpp $(CPPDIR)/Duke.h
	$(CC) -fpic $(INC) -c $(CPPDIR)/Duke.cpp

libduke.so:
	$(MAKE) -C ../duke-proxy

$(PROG)_wrap.o: $(PROG)_wrap.cxx
	$(CC) -fpic $(JAVA_INC) -c $(PROG)_wrap.cxx

$(PROG)_wrap.cxx: $(PROG).i | $(JAVA_ODIR)
	swig $(SWIG_FLAGS) $(SWIG_INC) $(PROG).i

$(PROG).i: ;

Duke.java dukeproxyj.java dukeproxyjJNI.java: $(PROG)_wrap.cxx ;

$(TARGET_DIR) $(JAVA_ODIR):
	-mkdir -p $@

$(JAVA_PROJ)/build/libs/duke-proxy.jar: Duke.java dukeproxyj.java dukeproxyjJNI.java | $(TARGET_DIR)
	@echo apply plugin: '"java"' > $(JAVA_PROJ)/build.gradle
	gradle -p $(JAVA_PROJ) build
	cp $(JAVA_PROJ)/build/libs/* $(TARGET_DIR)

install:
	mkdir -p $(DESTDIR)$(DUKEMAINDIR)$(INST_DIR)
	command cp $(JAVA_PROJ)/build/libs/*.jar $(DESTDIR)$(DUKEMAINDIR)$(INST_DIR)
	command cp $(TARGET_DIR)/*.so*           $(DESTDIR)$(GLOBAL_LIB_DIR)

clean:
	rm -fr *.o *.cxx $(JAVA_PROJ) $(TARGET_DIR)

uninstall:
	rm -rf $(DESTDIR)$(DUKEMAINDIR)$(INST_DIR)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
