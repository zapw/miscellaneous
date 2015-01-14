subdirs := Rcf_2.2 Rcf_2.0 server remoting_test_app

.PHONY: default all RCF SERVER REMOTING_TEST_APP install clean $(subdirs) rcf_remove

all:    RCF SERVER REMOTING_TEST_APP
		
#create symbolic link to correct rcf version
Rcf:
	@if boost_version=$$(grep "define BOOST_VERSION " /usr/include/boost/version.hpp); then \
		test "$$(printf "%s" "$$boost_version" | cut -d' ' -f3)" -lt 105000 && ln -sfn Rcf_2.0 Rcf  || ln -sfn Rcf_2.2 Rcf; \
	else \
		exit 1; \
	fi

RCF: | Rcf
	@printf "\n%s\n" "********************* build RCF library **************************"
	$(MAKE) -C Rcf

SERVER: | Rcf 
	@printf "\n%s\n" "********************* build remoting server application **************************"
	$(MAKE) -C server

REMOTING_TEST_APP:
	@printf "\n%s\n" "********************* build remoting test application **************************"
	$(MAKE) -C remoting_test_app

install:
	$(MAKE) -C server $@


clean: $(subdirs) rcf_remove
rcf_remove:
	rm -f Rcf

$(subdirs):
	$(MAKE) -C $@ clean

#Efficience tweaks:
#allow implicit rule look-ups only for these suffixes.
.SUFFIXES:

#prevents implicit rule look-ups for Makefile.
Makefile: ;
