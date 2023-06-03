# -*- mode: makefile-gmake; coding: utf-8; indent-tabs-mode: t; -*-

ANTLR_GRAMMAR=json
ANTLR_OUTDIR=gen
include antlr.defs

CPPFLAGS=-I/usr/local/include/antlr4-runtime
CXXFLAGS=-std=c++20
CXX=/usr/local/bin/g++-13

CXX_OUTDIR=build

VPATH=$(ANTLR_OUTDIR)
LIB=$(CXX_OUTDIR)/lib$(ANTLR_GRAMMAR).a

ANTLR_GENERATED_OBJS=$(patsubst %.cpp,%.o,$(ANTLR_GENERATED_SRCS))

$(LIB): ARFLAGS=-cr
$(LIB): $(LIB)($(ANTLR_GENERATED_OBJS))

clean:
	-rm -rf $(LIB)
