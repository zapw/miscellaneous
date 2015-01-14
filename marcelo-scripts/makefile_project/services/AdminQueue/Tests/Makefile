NAME := uniTestMain

OBJECTS := CAdminQueueUnitTest.o\
	CAdminQueueSample.o\
	CBasicAdminQueueTest.o\
	CAllAdminQueueTest.o\
	CPerProductAdminQueueTest.o
		
targets := $(NAME)
targets_preq := -lUtilities -lAdminQueue

include ../../preq.mk
DRIVER_LIBS := -lpcap -lc -lpci -lz -lboost_system -ldl
PVM_LIBS := -L/usr/share/pvm3/lib/LINUX/ -L/usr/share/pvm3/lib/LINUXX86_64/ -L/usr/local/pvm3/lib/LINUX64/ -L/usr/share/pvm3/lib/LINUXI386/ -lpvm3 -lgpvm3
LIBS := -lcppunit  $(DRIVER_LIBS) $(PVM_LIBS) 

DBG := -g
FLAGS := -fPIC -Wall
CXXFLAGS := $(FLAGS) $(DBG)

.PHONY: default install clean
default: $(NAME)

$(NAME): $(NAME).o $(OBJECTS)
	$(CXX) $(FLAGS) $(CPPFLAGS) -o $(NAME) $(NAME).o $(OBJECTS) $(LDFLAGS) $(LDLIBS) $(LIBS)

install: ;

clean:  
	rm -f *.o $(NAME) $(includes)

sources := $(OBJECTS:.o=.cpp)

$(eval $(auto_prerequisite_gen))
