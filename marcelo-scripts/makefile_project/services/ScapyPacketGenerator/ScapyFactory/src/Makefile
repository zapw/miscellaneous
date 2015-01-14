sources := $(wildcard *.cpp)
OBJECTS = $(patsubst %.cpp,%.o,$(sources))

python_version_full := $(wordlist 2,4,$(subst ., ,$(shell python --version 2>&1)))
python_version_major := $(word 1,${python_version_full})
python_version_minor := $(word 2,${python_version_full})
python_version_patch := $(word 3,${python_version_full})

python_lib := python${python_version_major}.${python_version_minor}

all_lib_inc := -I/usr/include/${python_lib}
set_inc := -lPacketGeneratorI -lUtilities  -lScapyPacketGenerator

include ../../../preq.mk

CXXFLAGS = -fPIC -Wall -g

.PHONY: all default
default: all

all: $(OBJECTS)

clean:
	rm -f  *.o $(includes)

$(eval $(auto_prerequisite_gen))
