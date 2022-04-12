# Make file for C-Unix Project 2022
# Pysogge
# 
# $: make init		## generate default required dir structure
# $: make build		## builds executable file 'cunix'
# $: make run		## runs 'cunix' with default arguments
# $: make depend	## generates dependencies for all files in the src directory
# $: make clean 	## removes all files in the current directory       	
# $: make test		## builds and runs all tests
# $: make help		## shows help options
#

help:
	@echo "Usage: make [target]"
	@echo "	init:			generate default required dir structure"
	@echo "	build:			builds the executable file 'cunix'"
	@echo "	run:			runs 'cunix' with default arguments"
	@echo "	depend:			generates dependencies for all files in the src directory"
	@echo "	clean:			removes all files in the current directory"
	@echo "	build-tests:	builds all tests"

# default dir structure
DIRS = {include,input,output,lib,obj,src,excsrc,excobj,exc,stash,test,testsrc,testobj,depn}

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
_SRCS = main.c btree.c
SRCS = $(patsubst %,$(SRCDIR)/%,$(_SRCS))

# define the C object files (.c => .o)
OBJDIR = obj
_OBJS = $(_SRCS:.c=.o)
OBJS = $(SRCS:.c=.o)
OBJSD = $(patsubst %,$(OBJDIR)/%,$(_OBJS))


# define the executable file 
_MAIN = cunix
EXECDIR = exc
MAIN = $(patsubst %,$(EXECDIR)/%,$(_MAIN))

# TESTDIR = test
# TESTSRCDIR = testsrc
# TESTOBJDIR = testobj
# TESTS = $(patsubst %,$(TESTDIR)/%,$(_TESTS))
# TEST_SRC = $(_TESTS:=.c)
# TEST_OBJ = $(_TESTS:=.o)
# TESTSRCS = $(patsubst %,$(TESTSRCDIR)/%,$(TEST_SRC))
# TESTOBJS = $(patsubst %,$(TESTOBJDIR)/%,$(TEST_OBJ))

# main build rules

.PHONY: depend clean test all

build:    $(MAIN)
		$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJSD) $(LFLAGS) $(LIBS)
		@echo  cunix has been compiled

$(MAIN): $(OBJSD)
		$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJSD) $(LFLAGS) $(LIBS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
		$(CC) -I$(INCLDIR) -c $< -o $@

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
	$(MAIN)

# End of Main Builds - Do not Delete

# Tests

## define the test files and directory
_TESTS = test-btree test-btree2

TESTDIR = test
TESTSRCDIR = testsrc
TESTOBJDIR = testobj
TESTS = $(patsubst %,$(TESTDIR)/%,$(_TESTS))
TEST_SRC = $(_TESTS:=.c)
TEST_OBJ = $(_TESTS:=.o)
TESTSRCS = $(patsubst %,$(TESTSRCDIR)/%,$(TEST_SRC))
TESTOBJS = $(patsubst %,$(TESTOBJDIR)/%,$(TEST_OBJ))

# $(TESTOBJDIR)/%.o: $(TESTSRCDIR)/%.c
# 		$(CC) -I$(INCLDIR) -c $< -o $@

build-tests: build $(TESTS)
# @echo hello3
# $(CC) $(CFLAGS) $(INCLUDES) -o $(TESTS) $(TESTOBJS) $(OBJSD) $(LFLAGS) $(LIBS)
# @echo  tests have been compiled

$(TESTS): %: $(TESTOBJS)
		@echo hello2
		$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

# $(TESTS): $(TESTOBJS)
# 		$(CC) $(CFLAGS) $(INCLUDES) -o $(TESTS) $(TESTOBJS) $(OBJSD) $(LFLAGS) $(LIBS)

$(TESTOBJDIR)/%.o: $(TESTSRCDIR)/%.c
		$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# testSomething :
# 	program.exe < input.txt > output.txt
# 	diff correct.txt output.txt

# # test-all: test-main test-btree


# test-btree:

# Clean --------------------------------------------------

clean:
		$(RM) ./$(OBJDIR)/*.o
		$(RM) ./$(EXECDIR)/*
		$(RM) ./$(TESTOBJDIR)/*.o
		$(RM) ./$(TESTDIR)/*
		$(RM) ./$(DEPNDIR)/$(_DEPN)