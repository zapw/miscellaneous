CC = g++
INC = -I./inc
LIB_OBJS =      chrqueue.o \
                cplfile.o \
                cplmatch.o \
                direader.o \
                enhance.o \
                errmsg.o \
                expand.o \
                freelist.o \
                getline.o \
                hash.o \
                history.o \
                homedir.o \
                ioutil.o \
                keytab.o \
                pathutil.o \
                pcache.o \
                stringrp.o \
                strngmem.o \
                version.o


%.o: %.c
	$(CC) $(INC) -c $<

.PHONY: default all stat
default: all

all: stat

stat: libtecla.a

libtecla.a: $(LIB_OBJS)
	ar -rcs libtecla.a *.o

clean:
	rm -f *.so *.a *.o

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
