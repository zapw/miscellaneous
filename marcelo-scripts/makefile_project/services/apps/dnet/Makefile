NAME := dnet

targets := $(NAME)
targets_preq := -lUtilities -lCommuneNet -lXMLParsers -lExecutionEngine

include ../../preq.mk

OBJECTS := 	src/CDnetRegression.o\
		src/CDnetTest.o\
		src/CDnetRegressionFileParser.o\
		src/dnet.o
DIRS := src 
CLEANDIRS := $(DIRS:%=clean-%) 

ifdef SVOS
DESTDIR ?= /
endif

EXT_LIBS := -lz -lboost_thread -lboost_filesystem -ldl -lrt -lxerces-c

LIBS := -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/lib/ -lpvm3 -lgpvm3  $(EXT_LIBS)

ifeq ($(shell uname -m), x86_64)
LIBS_DIR := /usr/lib64
else
LIBS_DIR := /usr/lib
endif

.PHONY:	$(DIRS) $(CLEANDIRS)

default: all

all: $(NAME)

NO_TESTS: $(NAME) 

clean: $(CLEANDIRS)
	rm -f $(NAME)
	
$(NAME): $(OBJECTS)
	$(CXX) $(CPPFLAGS) -o ./$(NAME) $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(OBJECTS): | $(DIRS) ;

$(DIRS):
	$(MAKE) -C $@


install: 
ifdef SVOS
	install -d $(DESTDIR)/usr/include/services/CommuneNet/app/InputFiles
	install InputFiles/*.xsd $(DESTDIR)/usr/include/services/CommuneNet/app/InputFiles/
else
	sudo mkdir -p /usr/include/services/CommuneNet/app/InputFiles
	sudo cp InputFiles/*.xsd /usr/include/services/CommuneNet/app/InputFiles/
endif

clean_lib: 
	sudo rm -f /usr/include/services/CommuneNet/app/InputFiles/*.xsd
	
$(CLEANDIRS): 
	$(MAKE) -C $(@:clean-%=%) clean
