# -*- mode: makefile-gmake; coding: utf-8; indent-tabs-mode: t; -*-

ANTLR_GRAMMAR=json
ANTLR_OUTDIR=gen
include antlr.defs

.NOTPARALLEL:

all: $(ANTLR_GENERATED_SRCS) $(ANTLR_GENERATED_HDRS)

clean:
	-rm -rf $(ANTLR_OUTDIR)/*

.SUFFIXES: .g4

$(ANTLR_MATCHRULE): %.g4
	antlr $(ANTLR_FLAGS) $<
