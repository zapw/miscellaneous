NAME := test_lib

sources := $(wildcard *.cpp)
OBJECTS := $(patsubst %.cpp,%.o,$(sources))

TEST_MAIN_OBJECT := $(NAME).o
TESTS_OBJECTS := $(filter-out $(TEST_MAIN_OBJECT), $(OBJECTS))

TESTS := $(TESTS_OBJECTS:%.o=%.out)

targets := $(NAME).out $(TESTS)
targets_preq := -lUtilities
include ../../preq.mk

DRIVER_LIBS := -lpcap -lc -lpci -lz -lboost_system -ldl
LIBS := -lcppunit -lpthread $(DRIVER_LIBS)

CXXFLAGS := -fPIC -Wall -g

.PHONY: default
default: $(NAME).out $(TESTS)

$(NAME).out: $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $(NAME).out $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

$(TESTS): %.out: %.o $(NAME).o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -o $(@) $< $(NAME).o $(LDFLAGS) $(LDLIBS) $(LIBS)

clean:
	rm -f *.o *.out $(includes)

$(eval $(auto_prerequisite_gen))
