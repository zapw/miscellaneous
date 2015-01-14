OUTPUT_DIR = ../bin
OUTPUT_FILE = pktgen_test

targets := $(OUTPUT_DIR)/pktgen_test.exe
targets_preq := -lpktgen
include ../../preq.mk

FLAGS := -Wall
CXXFLAGS := $(FLAGS) $(all_lib_inc)


.PHONY: default test clean

default: test

test: $(OUTPUT_DIR)/pktgen_test.exe

$(OUTPUT_DIR)/pktgen_test.exe: main.o
	$(CXX) $(FLAGS) $(CPPFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(includes) $(OUTPUT_DIR)/pktgen_test.exe *.o

sources := main.cpp

$(eval $(auto_prerequisite_gen))
