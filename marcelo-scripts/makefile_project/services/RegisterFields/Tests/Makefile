NAME := uniTestMain

TEST_MAIN_OBJECT = $(NAME).o

sources := $(wildcard *.cpp)
OBJECTS = $(patsubst %.cpp,%.o,$(sources))

TESTS_OBJECTS = $(filter-out $(TEST_MAIN_OBJECT), $(OBJECTS))
TESTS = $(TESTS_OBJECTS:%.o=%.out)

targets := $(NAME).out $(TESTS)

targets_preq := -lUtilities -lRegisterFields

include ../../preq.mk

CXXFLAGS := -fPIC -Wall -g
DRIVER_LIBS = -lpcap -lc -lpci -lz -lboost_system -ldl
FINAL_LIBS := -lcppunit  $(DRIVER_LIBS)
	
.PHONY: default

default:  $(NAME).out $(TESTS)

$(NAME).out: $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $@ $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

$(TESTS): %.out: %.o $(NAME).o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $(@) $(@:%.out=%.o) $(NAME).o $(LDFLAGS) $(LDLIBS) $(FINAL_LIBS)

clean:
	rm -f *.o *.out $(includes)

$(eval $(auto_prerequisite_gen))
