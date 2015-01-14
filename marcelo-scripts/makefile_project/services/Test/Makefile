.PHONY: default all GuiTest
default: all

all clean: GuiTest
		
ifneq ($(MAKECMDGOALS),)
ifneq ($(filter default all,$(MAKECMDGOALS)),)
$(info "********************* build GuiTest library **************************")
endif
else
$(info "********************* build GuiTest library **************************")
endif

GuiTest: 
	$(MAKE) -C $@ $(MAKECMDGOALS)
