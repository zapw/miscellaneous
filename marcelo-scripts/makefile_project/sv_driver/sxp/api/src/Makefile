.DELETE_ON_ERROR:
CC = g++ -pthread
LIB_OBJS = 	SxpPort.o

LIBS = -ldl

INC = -I../inc -I../../../api/inc 
DBG = -g
CFLAGS = -fPIC -Wall
CFLAGS += -D__PTHREAD

TARGET_SO=libSxpApi.so


ifeq ($(shell uname -m), x86_64)
LIBS_DIR = /usr/lib64
else
LIBS_DIR = /usr/lib
endif


.cpp.o:
	$(CC) $(INC) $(CFLAGS) $(DBG) -c $<

.PHONY: all install
all: $(LIB_OBJS)
	$(CC) $(INC) -lpci -lz -shared -Wl,-soname,$(TARGET_SO) -o $(TARGET_SO) $(LIB_OBJS) -lc
	
install:
	@echo $(LIBS_DIR)
	sudo cp $(TARGET_SO) $(LIBS_DIR)
	sudo /sbin/ldconfig -l $(LIBS_DIR)/$(TARGET_SO)
	sudo mkdir -p /usr/include/sv_driver/sxp
	sudo cp ../inc/*.h /usr/include/sv_driver/sxp

clean:
	rm -f *.so *.o $(includes)

sources = $(wildcard *.cpp)


#prefix source files names with a dot "." and add ".d" suffix
includes = $(foreach src,$(sources),$(dir $(src)).$(notdir $(src)).d)

#restore the name of the source file (this will remove the dot "." prefix from the filename)
define template
$(1)/$(patsubst .%,%,$(2))
endef

.SECONDEXPANSION:

#More efficient way of generating a file of prerequisites, only source files that have changed need to be rescanned to produce the new prerequisites
#Pattern rule to generate a file of prerequisites (i.e., a makefile)
#called .name.cpp.d from a C++ source file called name.cpp (this rule works for ANY source file suffix not just .cpp):
%.d: $$(call template,$$(@D),$$(*F))
	$(CC) $(INC) -MT '$(patsubst %$(suffix $<),%.o,$<)' -MT '$@' -MM $< > $@

#Include ".d" makefiles file only if not running clean goal
ifneq ($(MAKECMDGOALS), clean)
-include $(includes)
endif


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
