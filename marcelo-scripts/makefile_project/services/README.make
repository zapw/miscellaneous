Currently there are three places for documentation:
1) This file has an extremely breif introduction to using make and creating makefiles
2) preq.mk has documentation about its purpose how to make use of it and why.
3) copy_gnumakefile shell script has information about the script and what are GNUmakefile's used for.

** It's highly recommended to read this README *before* reading preq.mk, it has some basic concepts which are required to be understood before making use of preq.mk 

_________________________________________
Quick introduction to GNU make/Makefiles:

A rule is a target + any of its prerequisites and recipes:

target: prerequisites
        recipe

recipes always start with a TAB.
each recipe is passed to a new spawned shell

Default goal:
When make is run with no goal specified as argument, the first target read from the Makefile will become the default goal to execute.

Example:


make -C somedir/


Where somedir contains:
somedir/Makefile


and Makefile contains:


file:
        command


file2:
        command2


file3:
        command3



make will run only the first target named 'file1'

on the other hand if 'make -C somedir/ file3' , was invoked ; then

the recipe for 'file3' (command3) would've been executed only if 'file3' is not found.

make uses a system of timestamps in the command 'make -C somedir/ file3'

make would search for a target named 'file3' and any of its prerequisites in this case there aren't any, if a file named file3 already exists then 'command3' would not be executed.
if the file does not exist make would attempt to execute its recipe ( command3 ) in the hopes that recipe will create the file 'file3'


Targets with prerequisites:
_____________________________


file: otherfile otherfile2
        command

in this case even if 'file' already exists there is a change its recipe ( command ) will be executed.

Here make scans for the prerequisites of target 'file', being  otherfile otherfile2  , if their timestamp is newer then it means 'file' needs to be updated possibly using 'otherfile' and 'otherfile2' to create a new version of 'file', if on the other hand 'otherfile' and 'otherfile2' timestamps are older than "file's" timestamp then it assumes 'file' is already up to date and will not execute its recipe ( command )

'file' depends on 'otherfile' and 'otherfile2' this means these files must exist. In case they do not, make needs to know how to create them, in that case it will look for a target of name 'otherfile' in case  'otherfile' is missing or/and 'otherfile2' if 'otherfile2' is missing.


if it is unable to find a target with these names it will abort with:
         make: *** No rule to make target `otherfile', needed by `file'.  Stop.
or/and
         make: *** No rule to make target `otherfila2e', needed by `file'.  Stop.


let's write the missing rules:

file: otherfile otherfile2
        command


otherfile:
        Otherfile_command

otherfile2:
        Otherfile2_command


Since now we have 'otherfile' and 'otherfile2' rules defined make will try and invoke their recipes

here make will again run the same logic it did for the target 'file' looking for any prerequisites for targets 'otherfile' and 'otherfile2' and again check their timestamps against its targets
        since there aren't any prerequisites for either 'otherfile' nor 'otherfile2' it will stop here and execute the targets' recipes 'Otherfile_command'  and 'Otherfile2_command'

one at a time if not using parallel feature or both at ONCE if using parallel feature
after all of "file's" prerequisites that were missing are done invoking their recipes make will go back to the target 'file' and invoke its recipe 'command'.


A note on recipes and parallel feature, recipes are never executed in parallel, instead they run serially per example:

file: otherfile otherfile2
        command1
        command2
        command3
        command4

after make is done with "file's" prerequisites
        command1 to command4 will be executed serially one after the other.


parallel feature is for executing rules in parallel
per example   if I was to run  make -j2 or any higher number, and make concludes it needs to update the files 'otherfile' and 'otherfile2' ( since it could not find them after scanned "file's" prerequisites )

make would start both rules 'otherfile' and 'otherfile2' simultaneously but their recipes would still execute serially.


sometimes it's useful to include a file where additional prerequisites for a target can be read.
suppose there is a file called preq.mk that looks like this:

file: otherfile3 otherfile4
file1: otherfile3 otherfile4
file2: otherfile5 otherfile6
...
...

you can see something is strange here since there are no recipes for these targets, make will combine our previous prerequisites list for the target "file" in the rule:
file: otherfile otherfile2
	command1
	command2
	command3
	command4

with the target definition:
file: otherfile3 otherfile4

it's same as if written:
file: otherfile otherfile2 otherfile3 otherfile4
	command1
	command2
	command3
	command4

it isn't valid for a target to be defined more than once with a recipe, if make detects this it will print:

Makefile:5: warning: overriding recipe for target `file'
Makefile:2: warning: ignoring old recipe for target `file'

The last one read from the Makefile will be used.

if no recipe is found for a target it will try its Built-in implicit rules.

there is another syntax for writing rules with only one recipe:
file1: otherfile3 otherfile4 ; command1

the part after the semicolon is the name of the recipe to execute, if there is no recipe after the semicolon then the rule has an empty recipe
this is also how you avoid looking for an Built-in implicit rule for a target.

Example:
file1: otherfile3 otherfile4 ;
	
___________________________________________________________________________________________________________________________________________________________________________________
more info https://www.gnu.org/software/make/manual/make.html
