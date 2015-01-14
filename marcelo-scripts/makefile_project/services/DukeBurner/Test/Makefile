CC=g++
CPPFLAGS=-Wall -Werror -pedantic-errors -O0 -fPIC 
LIBS=-lcppunit
DBG=-g -ggdb
PROG=duke-utest
TEST_CLASS=CDukeTest
RES_DIR=Resources
TEST_DIR=Scripts
RES_SCRIPT_DIR=$(RES_DIR)/Scripts
RES_TEST=$(RES_DIR)/Test
ASSIST_SCRIPT=$(RES_SCRIPT_DIR)/test_assistant.sh
DUKE_KVM_POWER_CYCLE=$(RES_SCRIPT_DIR)/kvm_power_cycle.py
GEN_DUKE_TEST=$(RES_SCRIPT_DIR)/make_tests.sh

IMG_DIR=$(RES_DIR)/Images

.PHONY: default all run pcycle test-dukeviz test-dukepyctl test-dukejctl clean

default: test-dukeviz 

all: test-dukeviz test-dukepyctl test-dukejctl

$(TEST_DIR):
	-mkdir -p $(TEST_DIR)

run: $(PROG)
	./$(PROG)

$(PROG): main.o $(TEST_CLASS).o | $(TEST_DIR)
	$(CC)  $(CPPFLAGS) $(DBG) $^ -o $@ $(LIBS) 
	cp $(RES_TEST)/1_duke_power_cycle.sh $(TEST_DIR)
	$(ASSIST_SCRIPT) -d

main.o: main.cpp
	$(CC) $(INC) $(CPPFLAGS) $(DBG)  -c $<

$(TEST_CLASS).o: $(TEST_CLASS).cpp
	$(CC) $(INC) $(CPPFLAGS) $(DBG)  -c $<

pcycle:
	@$(DUKE_KVM_POWER_CYCLE) > /dev/null

test-dukeviz: $(PROG)
	$(GEN_DUKE_TEST) a dukeviz
	
test-dukepyctl: $(PROG)
	$(GEN_DUKE_TEST) b dukepyctl

test-dukejctl: $(PROG)
	$(GEN_DUKE_TEST) c dukejctl

clean:  
	rm -fr *.o $(PROG) $(IMG_DIR) $(TEST_DIR)

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile: ;
