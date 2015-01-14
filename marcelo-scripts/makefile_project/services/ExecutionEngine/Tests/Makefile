MAIN_CPP := uniTestMain

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))
 		
TESTS := CExecutionEngineUniTest.out CShuffledTestListIteratorUniTest.out CTestRawDataUniTest.out 
targets := $(MAIN_CPP).out $(TESTS)
targets_preq := -lUtilities -lCommuneNet -lXMLParsers -lExecutionEngine

INC := -I/usr/share/pvm3/include/ -I/usr/local/pvm3/include/
all_lib_inc := $(INC)
include ../../preq.mk

DRIVER_LIBS := -lpcap -lc -lpci -lz -lboost_system -ldl -lxerces-c
LIBS := -L/usr/lib64 -L/usr/local/lib -lcppunit $(DRIVER_LIBS)

PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
FINAL_LIBS := $(PVM_LIBS) $(LIBS)

CXXFLAGS := -fPIC -Wall -g

default: $(MAIN_CPP).out $(TESTS)

$(MAIN_CPP).out: $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(INC) $(CXXFLAGS) -o $(MAIN_CPP).out $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

$(TESTS): %.out : %.o $(MAIN_CPP).o
	$(CXX) $(CPPFLAGS) $(INC) $(CXXFLAGS) -o $(@) $< $(MAIN_CPP).o $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

clean: 	
	rm -f  *.o $(MAIN_CPP).out $(TESTS) $(includes)


$(eval $(auto_prerequisite_gen))
