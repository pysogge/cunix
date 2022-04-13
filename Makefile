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

help:
	@echo "Usage: make [target]"
	@echo "	init:			generate default required dir structure"
	@echo "	build:			builds the executable file 'cunix'"
	@echo "	run:			runs 'cunix' with default arguments"
	@echo "	depend:			generates dependencies for all files in the src directory"
	@echo "	clean:			removes all files in the current directory"
	@echo "	build-tests:	builds all tests"
	@echo "	test-all:		runs all tests"

# default dir structure
DIRS = ./{include,input,output,lib,obj,src,excsrc,excobj,exc,stash,test,testsrc,testobj,testin,testout,testargs,testdiff,depn,logs}

LOGSDIR=logs

# define the C compiler to use
CC = gcc

# define any compile-time flags
CFLAGS = -Wall -g

# define directories containing header files other than /usr/include
INCLDIR = include
INCLUDES = -I$(INCLDIR)

# define library paths in addition to /usr/lib
LIBDIR = lib
LIBS = -lutil
LFLAGS = -L$(LIBDIR)

# define the C source files
SRCDIR = src
_SRCS = btree.c
SRCS = $(patsubst %,$(SRCDIR)/%,$(_SRCS))

# define the C object files (.c => .o)
OBJDIR = obj
_OBJS = $(_SRCS:.c=.o)
# OBJS = $(SRCS:.c=.o)
OBJS = $(patsubst %,$(OBJDIR)/%,$(_OBJS))

# define the executable files
_EXECS = cunix
EXECDIR = exc
EXECSRCDIR = $(EXECDIR:=src)
EXECOBJDIR = $(EXECDIR:=obj)
EXECS = $(patsubst %,$(EXECDIR)/%,$(_EXECS))
EXEC_SRCS = $(_EXECS:=.c)
EXEC_OBJS = $(_EXECS:=.o)
EXECSRCS = $(patsubst %,$(EXECSRCDIR)/%,$(EXEC_SRCS))
EXECOBJS = $(patsubst %,$(EXECOBJDIR)/%,$(EXEC_OBJS))

# EXECS build rules

.PHONY: init depend clean test all build run build-tests test-all printrun

build: $(OBJS) $(EXECS) 

$(EXECS): %: $(EXECOBJS)
		$(CC) $(CFLAGS) $(INCLUDES) -o $@ $< $(OBJS)

$(EXECOBJDIR)/%.o: $(EXECSRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

## Dependency generation rules

DEPNDIR = depn
_DEPN = .depend
DEPN = $(patsubst %,$(DEPNDIR)/%,$(_DEPN))
depend: $(DEPN)

$(DEPN): $(SRCS)
		rm -f "$@"
		$(CC) $(CFLAGS) $(INCLUDES) -MM $^ -MF "$@"

# include .depend

init:
	@mkdir -vp $(DIRS)

run:
	$(EXECS)

printrun:
	@echo "./$(EXECS)"

# End of EXECS Builds - Do not Delete

# Tests

## define the test files and directory
_TESTS = test-btree test-btree2 test-argpar test-input_int_array

TESTDIR = test
TESTSRCDIR = testsrc
TESTOBJDIR = testobj
TESTS = $(patsubst %,$(TESTDIR)/%,$(_TESTS))
TEST_SRC = $(_TESTS:=.c)
TEST_OBJ = $(_TESTS:=.o)
TESTSRCS = $(patsubst %,$(TESTSRCDIR)/%,$(TEST_SRC))
TESTOBJS = $(patsubst %,$(TESTOBJDIR)/%,$(TEST_OBJ))

TESTINPUTDIR = testin
TESTOUTPUTDIR = testout
TEST_FILES = $(_TESTS:=.txt)
TESTINS = $(patsubst %,$(TESTINPUTDIR)/%,$(TEST_FILES))

TESTARGDIR = testargs
TESTARGS = $(patsubst %,$(TESTARGDIR)/%,$(TEST_FILES))

TESTDIFFDIR=testdiff

## build and run tests
build-tests: build $(TESTS)

$(TESTDIR)/%: $(TESTOBJDIR)/%.o
		$(CC) $(CFLAGS) $(INCLUDES) -o $@ $< $(OBJS)

$(TESTOBJDIR)/%.o: $(TESTSRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

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

# Clean 

clean:
		$(RM) ./$(OBJDIR)/*.o
		$(RM) ./$(EXECDIR)/*
		$(RM) ./$(EXECOBJDIR)/*.o
		$(RM) ./$(TESTOBJDIR)/*.o
		$(RM) ./$(TESTDIR)/*
		$(RM) ./$(TESTOUTPUTDIR)/*
		$(RM) ./$(LOGSDIR)/*
		$(RM) ./$(DEPNDIR)/$(_DEPN)