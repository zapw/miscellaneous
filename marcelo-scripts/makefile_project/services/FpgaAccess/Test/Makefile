OBJECTS:=veloce_test.o
CXXFLAGS=-Wall -g -Wextra -fPIC
set_inc := -lftd2xx -lFpgaRegisterAccessApi -lVeloceProxy -lgenesys_proxy

include ../../preq.mk

.PHONY: all install
all: $(OBJECTS)

install: ;
	
clean:
	rm -f *.o $(includes)

sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
