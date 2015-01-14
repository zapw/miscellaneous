CC = g++ 
NAME = RCF

LIBS = -lpthread -lboost_system
INC = -Iinclude -I/usr/include/boost
DBG = -g
CFLAGS = -fPIC -DRCF_USE_BOOST_ASIO -Wno-deprecated 
#-DRCF_NO_AUTO_INIT_DEINIT

RCF.o:
	$(CC) $(INC) $(CFLAGS) $(DBG) $(LIBS) -c src/RCF/RCF.cpp

clean:
	rm -f *.so* *.o

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
