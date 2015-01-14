destination_path := $(wildcard Rdl2ConfigFiles/generated/*/ConfigFiles/ForDenver)
source_rdls := $(wildcard Rdl2ConfigFiles/rdl/*/*)
include_files := $(wildcard Rdl2ConfigFiles/templates/api/shared/src/*/*)
rdl := Rdl2ConfigFiles/rdl.rb

vpath %.cfg $(destination_path) 

HLPMapFile.cfg: $(source_rdls) $(include_files) $(rdl)
	cd Rdl2ConfigFiles ; ./RDL_2_ConfigFiles.sh -t Denver

$(source_rdls) $(include_files) $(rdl): ;

clean:
	$(MAKE) -C Rdl2ConfigFiles clean_all

install:

cleanlib_old: clean


.SUFFIXES:
