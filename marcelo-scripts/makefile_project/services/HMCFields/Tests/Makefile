NAME := uniTestMain

targets := $(NAME)
targets_preq := -lUtilities -lHMCFields

all_lib_inc := -I../inc
include ../../preq.mk
OBJECTS := CHMCFieldsUnitTest.o
		
DRIVER_LIBS := -lpcap -lc -lpci -lz -lboost_system -ldl
PVM_LIBS := -L /usr/share/pvm3/lib/LINUX/  -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS := -lcppunit  $(DRIVER_LIBS) $(PVM_LIBS)

CXXFLAGS := -fPIC -Wall -g

.PHONY: default install clean

default: $(NAME)

$(NAME): $(NAME).o $(OBJECTS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $(NAME) $(NAME).o $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

install:
	
clean:  
	rm -f   *.o $(NAME) ./$(NAME) $(includes)

sources := $(OBJECTS:.o=.cpp)

$(eval $(auto_prerequisite_gen))
