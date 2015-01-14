.DELETE_ON_ERROR:

CPPFLAG = -std=c++0x
DBG = -g3 -ggdb
PARAMDIR = param
PARAM_INC_DIR = $(PARAMDIR)/inc
PARAM_OBJ_DIR = $(PARAMDIR)/obj
PARAM_SRC_DIR = $(PARAMDIR)/src
SRCDIR = src
INCDIR = inc
OBJDIR = obj
LIBDIR = lib
INC=-I$(PARAM_INC_DIR) -I/usr/include/cppunit -I$(INCDIR)
SRCS := $(wildcard $(SRCDIR)/*.cpp)
PARAM_OBJS := $(patsubst %.cpp,%.o,$(addprefix $(PARAM_OBJ_DIR)/,$(notdir $(wildcard $(PARAM_SRC_DIR)/*.cpp))))
OBJS = $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SRCS))
LIB=libvarparamtest.a

vpath %.a $(LIBDIR)


$(LIB): $(OBJS) $(PARAM_OBJS)
	ar rvs $(LIBDIR)/$@ $(OBJS) $(PARAM_OBJS)

$(OBJS): | $(OBJDIR) $(LIBDIR)

$(OBJDIR): 
	-mkdir $(OBJDIR)

$(LIBDIR):
	-mkdir $(LIBDIR)

$(PARAM_OBJS): 
	$(MAKE) -C $(PARAMDIR) obj/$(@F)

$(OBJDIR)/VarparamTestRunner.o: $(SRCDIR)/VarparamTestRunner.cpp \
        $(INCDIR)/VarparamTestConfigurator.h $(INCDIR)/macro.h
	g++ -c $< $(INC) $(CPPFLAG) $(DBG) -o $@

$(OBJDIR)/VarparamTestConfigurator.o: $(SRCDIR)/VarparamTestConfigurator.cpp \
	    $(INCDIR)/VarparamTestConfigurator.h $(INCDIR)/VarparamTestRegistry.h \
		$(PARAM_INC_DIR)/ParamList.h $(PARAM_INC_DIR)/Param.h $(INCDIR)/macro.h
	g++ -c $< $(INC) $(CPPFLAG) $(DBG) -o $@

clean:
	$(MAKE) clean -C $(PARAMDIR)
	rm -fr $(OBJDIR) $(LIBDIR)


#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:
.SUFFIXES: .a .o .c .cpp .h

#prevents implicit rule look-ups for Makefile.
Makefile:;
