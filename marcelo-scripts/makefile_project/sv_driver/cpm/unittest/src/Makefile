.DELETE_ON_ERROR:
CXX = g++
CFLAGS = -g -c -Wall# -Werror
VPATH = /usr/local/lib /usr/lib/ #../../../sv_driver/api/lib/ ../bin
PROJ_NAME = svDriverUnitTester
LIBS = -ldl -lcppunit -lCpmDriverApi -lpci -lz -lboost_system -lrt
LIB_DIR = -L /usr/lib64/ -L /usr/local/lib -L ../../api/lib/
INCLUDE_DIR = -I../../api/inc/ -I../inc -I/usr/local/include  -I/usr/include/sv_driver/api/cpm
#DEPENDENCY_LIBS = libcppunit.a #libDriverApi.a
TEST_MAIN = UnitTestsMain


SOURCES = \
	UnitTestsMain.cpp \
	CpmBaseTestSuit.cpp \
	CpmUniTest.cpp \

#	Cpm_unit_test.cpp


OBJECTS = $(SOURCES:.cpp=.o)

all: default

default: $(PROJ_NAME)

$(PROJ_NAME):  $(OBJECTS) ../../api/lib/libCpmDriverApi.a # $(DEPENDENCY_LIBS)
	$(CXX) -o cpm.test $(FLAGS)  $(SOURCES) $(INCLUDE_DIR) $(LIB_DIR) $(LIBS)
	#$(CXX) $(FLAGS) -o cpm.test   $(OBJECTS) $(INCLUDE_DIR) $(LIB_DIR) $(LIBS)
	mkdir -p ../bin
	mv *.test ../bin

../../api/lib/libCpmDriverApi.a:
	$(MAKE) -C ../../api/src/

%.o: %.cpp
	$(CXX) $(INCLUDE_DIR) $(CFLAGS)  $< -o $@
	#cp *.o ../bin

clean:
	rm -f $(includes)
	rm -rf $(PROJ_NAME)  *.o
	rm -rf ../bin/$(PROJ_NAME) ../bin/*.o ../bin/*.test

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
	
#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(SOURCES),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(CPPFLAGS) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif
