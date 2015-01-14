APP = lfpga_burner
EXE = $(APP)

OBJECTS=DukeCSR.o\
	VeloceCSR.o\
	RegisterCommandLine.o\
	lfpga_burner.o\
	FpgaReset.o

targets := duke_csr veloce_csr lfpga_burner fpga_reset 
targets_preq := -lFpgaRegisterAccessApi -lDukeProxy -lVeloceProxy -lgenesys_proxy -lftd2xx
include ../../preq.mk

CXXFLAGS := -Wall -g -Wextra -fPIC 
LIBS := -ldl -lpthread

python_version_full := $(wordlist 2,4,$(subst ., ,$(shell python --version 2>&1)))
python_version_major := $(word 1,${python_version_full})
python_version_minor := $(word 2,${python_version_full})
python_version_patch := $(word 3,${python_version_full})

my_cmd.python.2 := python2 some_script.py2
my_cmd.python.3 := python3 some_script.py3
python_ver := python${python_version_major}.${python_version_minor}

PYTHON_LIB = $(python_ver)

all: duke_csr veloce_csr lfpga_burner fpga_reset _fpga_register_access_py.so

duke_csr: DukeCSR.o RegisterCommandLine.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS)  DukeCSR.o RegisterCommandLine.o -o duke_csr $(LDFLAGS) $(LDLIBS) $(LIBS)

veloce_csr: VeloceCSR.o RegisterCommandLine.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) VeloceCSR.o RegisterCommandLine.o -o veloce_csr $(LDFLAGS) $(LDLIBS) $(LIBS)

lfpga_burner: lfpga_burner.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) lfpga_burner.o -o lfpga_burner $(LDFLAGS) $(LDLIBS) $(LIBS)

fpga_reset: FpgaReset.o
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) FpgaReset.o -o fpga_reset $(LDFLAGS) $(LDLIBS) $(LIBS)

fpga_proxy_wrap.cxx: fpga_proxy.i
	swig -python -c++ -I../FpgaAccessApi fpga_proxy.i

fpga_proxy.i: ;
	
fpga_proxy_wrap.o: fpga_proxy_wrap.cxx
	$(CXX) -fpic -c fpga_proxy_wrap.cxx -I/usr/include/$(PYTHON_LIB)/ -I../FpgaAccessApi

_fpga_register_access_py.so: fpga_proxy_wrap.o
	$(CXX) -shared fpga_proxy_wrap.o -Wall -fpic -rdynamic $(INC) -o _fpga_register_access_py.so $(LIBS)

python_install:
	sudo cp _fpga_register_access_py.so /usr/lib64/$(PYTHON_LIB)
	sudo cp fpga_register_access_py.py /usr/lib64/$(PYTHON_LIB)

install_tools:
	sudo cp lfpga_burner /usr/bin
	sudo cp fpga_reset /usr/bin

install: python_install install_tools

clean:
	rm -f  *.o lfpga_burner *.cxx *.so *.py *.pyc fpga_reset duke_csr veloce_csr $(includes)

.PHONY: install_tools install python_install all clean
	
sources := $(OBJECTS:%.o=%.cpp)

$(eval $(auto_prerequisite_gen))
