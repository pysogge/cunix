# Make file for C-Unix Project 2022
# Pysogge
# 
# $: make init		## generate default required dir structure
# $: make			## builds executable file 'cunix'
# $: make depend	## generates dependencies for all files in the src directory
# $: make clean 	## removes all files in the current directory       	
# $: make test		## builds and runs all tests
#

# default dir structure
DIRS = {include,input,output,lib,obj,src,stash,test}

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
MAIN = cunix

# main build rules

.PHONY: depend clean test all

all:    $(MAIN)
		$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJSD) $(LFLAGS) $(LIBS)
		@echo  cunix has been compiled

$(MAIN): $(OBJSD)
		$(CC) $(CFLAGS) $(INCLUDES) -o $(MAIN) $(OBJSD) $(LFLAGS) $(LIBS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
		$(CC) -I$(INCLDIR) -c $< -o $@

clean:
		$(RM) ./$(OBJDIR)/*.o *~ $(MAIN)
		$(RM) ./$(SRCDIR)/*.o
		$(RM) ./.depend

depend: .depend

.depend: $(SRCS)
		rm -f "$@"
		$(CC) $(CFLAGS) $(INCLUDES) -MM $^ -MF "$@"

include .depend

init:
	@mkdir -vp $(DIRS)

# End of File - Do Not Delete