HOST=$(shell hostname)

ifeq ($(HOST),ladj1262)
include $(CURDIR)/jerusalem_team.mk
else
include $(CURDIR)/kiev_team.mk
endif

# Shared folder directory structure
#DenverData
#└───Out
#└───FlatNVM
#│   └───BurnImages
#│       └─── Adaptive
#│       └─── Update
#│       └─── Preservation
#│   └───Components
#│       └─── Adaptive
#│       └─── Update
#│       └─── Preservation

.PHONY: mount ssh regression update adaptive preservation links update_links preservation_links adaptive_links
mount:

	mkdir -p $(CURDIR)/DenverData
	sudo umount -lf $(CURDIR)/DenverData || { echo "umount failed" ; : ; }
	sshfs -o nonempty $(SHARED_DIR) $(CURDIR)/DenverData

ssh:
	ssh-keygen
	ssh-copy-id -i $(DUT_SERVER)


regression:
	xmllint --xinclude --output regressions/RemoteRegression.xml regressions/RemoteRegressionTemplate.xml
	./Denver -r regressions/RemoteRegression.xml -s setups/$(REMOTE_SETUP_FILE) -o $(OUTPUT_DIR)
update:
	xmllint --xinclude --output regressions/UpdateRegression.xml regressions/UpdateRegressionTemplate.xml
	./Denver -r regressions/UpdateRegression.xml -s setups/$(REMOTE_SETUP_FILE) -o $(OUTPUT_DIR)

adaptive:
	xmllint --xinclude --output regressions/AdaptiveRegression.xml regressions/AdaptiveRegressionTemplate.xml
	./Denver -r regressions/AdaptiveRegression.xml -s setups/$(REMOTE_SETUP_FILE) -o $(OUTPUT_DIR)

preservation:
	xmllint --xinclude --output regressions/PreservationRegression.xml regressions/PreservationRegressionTemplate.xml
	./Denver -r regressions/PreservationRegression.xml -s setups/$(REMOTE_SETUP_FILE) -o $(OUTPUT_DIR)

links: update_links preservation_links adaptive_links

update_links:
	rm -f $(CURDIR)/DenverData/FlatNVM/BurnImages/Update/Image.bin
	rm -f $(CURDIR)/DenverData/FlatNVM/Components/Update/Component.bin
	ln -s $(lastword $(sort $(shell find $(CURDIR)/DenverData/FlatNVM/BurnImages/Update/$(CARD_TYPE)_*_CSS_*.bin -maxdepth 1 -type f)))  $(CURDIR)/DenverData/FlatNVM/BurnImages/Update/Image.bin
	ln -s $(lastword $(sort $(shell find $(CURDIR)/DenverData/FlatNVM/Components/Update/FLAT_FPK_*_CSS_*.bin -maxdepth 1 -type f)))  $(CURDIR)/DenverData/FlatNVM/Components/Update/Component.bin

preservation_links:
	rm -f $(CURDIR)/DenverData/FlatNVM/BurnImages/Preservation/Image.bin
	rm -f $(CURDIR)/DenverData/FlatNVM/Components/Preservation/FPK_Component_imageA.bin
	ln -s $(lastword $(sort $(shell find $(CURDIR)/DenverData/FlatNVM/BurnImages/Preservation/$(CARD_TYPE)_*_CSS_*.bin -maxdepth 1 -type f)))  $(CURDIR)/DenverData/FlatNVM/BurnImages/Preservation/Image.bin
	ln -s $(lastword $(sort $(shell find $(CURDIR)/DenverData/FlatNVM/Components/Preservation/FLAT_FPK_*_CSS_*.bin -maxdepth 1 -type f)))  $(CURDIR)/DenverData/FlatNVM/Components/Preservation/FPK_Component_imageA.bin

adaptive_links:
	rm -f $(CURDIR)/DenverData/FlatNVM/BurnImages/Adaptive/Image.bin
	ln -s $(lastword $(sort $(shell find $(CURDIR)/DenverData/FlatNVM/BurnImages/Adaptive/$(CARD_TYPE)_*_CSS_*.bin -maxdepth 1 -type f)))  $(CURDIR)/DenverData/FlatNVM/BurnImages/Adaptive/Image.bin

