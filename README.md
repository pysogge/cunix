# C Unix
## Unix Command Line Tools
## Pysogge

```bash
# $: make init			## generate default required dir structure
# $: make build			## builds executable file 'cunix'
# $: make run			## runs 'cunix' with default arguments
#
# $: make depend		## generates dependencies for all files in src
# $: make clean 		## removes all files in the current directory       	
# $: make help			## shows help options
# 
# $: make build-tests	## builds all tests
# $: make test-all		## runs all tests
```

## Run 'cunix' manually with default arguments (after build)

```bash
./exc/cunix
```

## Dir Structure
```bash
- src/      ## source files for functions, structs, etc.
- excsrc/   ## source files for executables (i.e. with main function)
- testsrc/  ## source files for test executables (also with main functions)
- include/  ## include files (headers, .h files)

- input/    ## input files
- output/   ## output files
- testin/   ## input files for tests
- testout/  ## output files for tests
- testdiff/ ## diff files for tests

- *obj/     ## object files (will be deprecated/nested)

- exc/      ## main program executables
- tests/    ## test executables

- lib/      ## libraries  
- depn/     ## dependencies list dir
- stash/    ## stash dir (an untracked dir for working local files)
```