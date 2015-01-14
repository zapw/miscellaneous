MAIN_CPP := uniTestMain

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))
 		
TESTS := CDescriptorFieldsUnitTest.out  CDescsInterfaceUnitTest.out 
targets := $(MAIN_CPP).out $(TESTS)

$(MAIN_CPP).out_preq := -lUtilities -lDescriptorFields
CDescsInterfaceUnitTest.out_preq  := $($(MAIN_CPP).out_preq)
CDescriptorFieldsUnitTest.out_preq  := $($(MAIN_CPP).out_preq)

LIBS := -lcppunit -lpcap -lc -lpci -lz -lboost_system -ldl 

PVM_LIBS := -L /usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
FINAL_LIBS := $(LIBS) $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

include  ../../preq.mk

.PHONY: default clean
default: $(MAIN_CPP).out $(TESTS)


$(MAIN_CPP).out:  $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $(MAIN_CPP).out $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

$(TESTS): %.out: %.o $(MAIN_CPP).o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $(@) $< $(MAIN_CPP).o $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)
clean: 	
	rm -f *.o *.out $(includes)

$(eval $(auto_prerequisite_gen))
