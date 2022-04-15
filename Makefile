# Make file for C-Unix Project 2022
# Pysogge
# 
# $: make init			## generate default required dir structure
# $: make build			## builds executable file 'cunix'
# $: make run			## runs 'cunix' with default arguments
#
# $: make printrun		## prints the run command (for use with args, etc.)	
# $: make depend		## generates dependencies for all files in the src directory
# $: make clean 		## removes all files in the current directory       	
# $: make help			## shows help options
# 
# $: make build-tests	## builds all tests
# $: make test-all		## runs all tests
#

# targets
.PHONY: init depend clean test all build run build-tests test-all printrun help

# help
help:
	@echo "Usage: make [target]"
	@echo "	init:			generate default required dir structure"
	@echo "	build:			builds the executable file 'cunix'"
	@echo "	run:			runs 'cunix' with default arguments"
	@echo "	depend:			generates dependencies for all files in the src directory"
	@echo "	clean:			removes all files in the current directory"
	@echo "	build-tests:	builds all tests"
	@echo "	test-all:		runs all tests"

###################### defines ######################
# define the executable files (will generate a .c execsrc file as well)
_EXECS = cunix

# define the C object (non-executable) source files
_SRCS:=btree.c

# define test files 
_TESTS:=test-btree test-btree2 test-argpar test-input_int_array

# define dependency text file
_DEPN = .depend

# define the C compiler to use
CC:=gcc

# define any compile-time flags
CFLAGS:=-Wall -g

# define library paths in addition to /usr/lib
LIBS:=-lutil
LFLAGS:=-L$(LIBDIR)

# define directories containing header files other than /usr/include
SRCDIR:=src
OBJDIR:=obj
EXECDIR:=exc
EXECSRCDIR = $(EXECDIR:=src)
EXECOBJDIR = $(EXECDIR:=obj)

LIBDIR:=lib
DEPNDIR:=depn
INCLDIR:=include

INPUTDIR:=input
OUTPUTDIR:=output

LOGSDIR:=logs

TESTDIR:=test
TESTSRCDIR:=testsrc
TESTOBJDIR:=testobj

TESTINPUTDIR:=testin
TESTOUTPUTDIR:=testout
TESTDIFFDIR:=testdiff
TESTARGDIR:= testargs

STASH:=stash

# default dir structure
DIRS:={$(INCLDIR),$(INPUTDIR),$(OUTPUTDIR),$(LIBDIR),$(OBJDIR),$(SRCDIR),$(EXECSRCDIR),$(EXECOBJDIR),$(EXECDIR),$(STASH),$(TESTDIR),$(TESTSRCDIR),$(TESTOBJDIR),$(TESTINPUTDIR),$(TESTOUTPUTDIR),$(TESTARGDIR),$(TESTDIFFDIR),$(DEPNDIR),$(LOGSDIR)}

###################### computes ######################
# compute the object filepaths
SRCS = $(patsubst %,$(SRCDIR)/%,$(_SRCS))

# compute the C object files (.c => .o)
_OBJS = $(_SRCS:.c=.o)
OBJS = $(patsubst %,$(OBJDIR)/%,$(_OBJS))

# compute executable source and object filepaths
EXEC_SRCS = $(_EXECS:=.c)
EXEC_OBJS = $(_EXECS:=.o)
EXECS = $(patsubst %,$(EXECDIR)/%,$(_EXECS))
EXECSRCS = $(patsubst %,$(EXECSRCDIR)/%,$(EXEC_SRCS))
EXECOBJS = $(patsubst %,$(EXECOBJDIR)/%,$(EXEC_OBJS))

# compute include command
INCLUDES = -I$(INCLDIR)

# compute dependency generation paths
DEPN = $(patsubst %,$(DEPNDIR)/%,$(_DEPN))

# compute test source filepaths
TESTS = $(patsubst %,$(TESTDIR)/%,$(_TESTS))
TEST_SRC = $(_TESTS:=.c)
TEST_OBJ = $(_TESTS:=.o)
TESTSRCS = $(patsubst %,$(TESTSRCDIR)/%,$(TEST_SRC))
TESTOBJS = $(patsubst %,$(TESTOBJDIR)/%,$(TEST_OBJ))
TEST_FILES = $(_TESTS:=.txt)
TESTINS = $(patsubst %,$(TESTINPUTDIR)/%,$(TEST_FILES))
TESTARGS = $(patsubst %,$(TESTARGDIR)/%,$(TEST_FILES))

###################### rules ######################
# build rules
build: $(OBJS) $(EXECS) 

$(EXECS): %: $(EXECOBJS)
		$(CC) $(CFLAGS) $(INCLUDES) -o $@ $< $(OBJS)

$(EXECOBJDIR)/%.o: $(EXECSRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# dependency generation rules
depend: $(DEPN)

.depend: $(SRCS)
		rm -f "$@"
		$(CC) $(CFLAGS) $(INCLUDES) -MM $^ -MF "$@"

# initialization of dirs
init:
	@mkdir -vp $(DIRS)

run:
	$(EXECS)

printrun:
	@echo "./$(EXECS)"

## build and run tests
build-tests: build $(TESTS)

$(TESTDIR)/%: $(TESTOBJDIR)/%.o
		$(CC) $(CFLAGS) $(INCLUDES) -o $@ $< $(OBJS)

$(TESTOBJDIR)/%.o: $(TESTSRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# run all tests
test-all:$(TESTDIR)/*
		i=0 ;
		for file in $^ ; do \
			i=$$((i+1)) ; \
			printf '%20s\n' | tr ' ' - ; \
			printf "Test: %05d\n" $${i} ; \
			ISINFILE=false ; \
			ISDIFFFILE=false ; \
			ISARGFILE=false ; \
			TESTINFILE="$${file//$(TESTDIR)\//$(TESTINPUTDIR)/}.txt"; \
			TESTOUTFILE="$${file//$(TESTDIR)\//$(TESTOUTPUTDIR)/}.txt"; \
			TESTDIFFFILE="$${file//$(TESTDIR)\//$(TESTDIFFDIR)/}.txt"; \
			TESTARGFILE="$${file//$(TESTDIR)\//$(TESTARGDIR)/}.txt"; \
			if [ -f "$${TESTARGFILE}" ] ; then \
				ISARGFILE=true ; \
			fi ; \
			if [ -f "$${TESTINFILE}" ] ; then \
				ISINFILE=true ; \
			fi ; \
			if [ -f "$${TESTDIFFFILE}" ] ; then \
				ISDIFFFILE=true ; \
			fi ; \
			BASHCOMMAND="$${file}" ; \
			DIFFCOMMAND="" ; \
			if $${ISARGFILE} ; then \
				BASHCOMMAND="$${BASHCOMMAND} $$(cat $${TESTARGFILE})"; \
			fi ; \
			if $${ISINFILE} ; then \
				echo "$${BASHCOMMAND} < $${TESTINFILE} > $${TESTOUTFILE}" ; \
				$${BASHCOMMAND} < $${TESTINFILE} > $${TESTOUTFILE}; \
			else \
				echo "$${BASHCOMMAND} > $${TESTOUTFILE}" ; \
				$${BASHCOMMAND} > $${TESTOUTFILE}; \
			fi ; \
			if $${ISDIFFFILE} ; then \
				DIFFCOMMAND="diff $${TESTDIFFFILE} $${TESTOUTFILE} "; \
				echo "$${DIFFCOMMAND}" ; \
				$${DIFFCOMMAND} ; \
			fi ; \
			echo "output: $${TESTOUTFILE}" ; \
		done >&1 | tee ${LOGSDIR}/test-all.log
		@echo "All Test Results: ${LOGSDIR}/test-all.log and $(TESTOUTPUTDIR)/*.txt"

printtests: $(TESTDIR)/*
		for file in $^ ; do \
			echo ./$${file} ; \
		done

# clean 
clean:
		$(RM) ./$(OBJDIR)/*.o
		$(RM) ./$(EXECDIR)/*
		$(RM) ./$(EXECOBJDIR)/*.o
		$(RM) ./$(TESTOBJDIR)/*.o
		$(RM) ./$(TESTDIR)/*
		$(RM) ./$(TESTOUTPUTDIR)/*
		$(RM) ./$(LOGSDIR)/*
		$(RM) ./$(DEPNDIR)/$(_DEPN)

# remove temporary dirs (obj, output)
uninit:
		$(RM) -rf ./$(OBJDIR)
		$(RM) -rf ./$(EXECOBJDIR)
		$(RM) -rf ./$(TESTOBJDIR)
		$(RM) -rf ./$(TESTOUTPUTDIR)/*
