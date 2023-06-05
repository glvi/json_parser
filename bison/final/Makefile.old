# -*- mode: makefile-gmake; coding: utf-8; -*-

BISON = /usr/local/opt/bison/bin/bison
FLEX  = /usr/local/opt/flex/bin/flex
DOT   = /usr/local/bin/dot

CXX       = /usr/local/opt/gcc/bin/g++-13
CXXFLAGS  = -std=c++20
CPPFLAGS += -I /usr/local/opt/gcc/include/c++/13
LDFLAGS  += -L /usr/local/opt/gcc/lib/gcc/13

all: json json_parser.pdf

%.cc %.hh %.html %.gv: %.yy
	$(BISON) $(BISONFLAGS) --html --graph -o $*.cc $<

%.pdf: %.gv
	$(DOT) -Tpdf -o$@ $<

%.cc: %.ll
	$(FLEX) $(FLEXFLAGS) -o$@ $<

%.o: %.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o$@ $<

json: json.o json_parser.o json_scanner.o
	$(CXX) $(LDFLAGS) -o $@ $^

json.o: json_parser.hh json.hh
json_parser.o: json_parser.hh
json_scanner.o: json_parser.hh

check: site.exp
	runtest

site.exp: json
	@echo "creating site.exp"
	@-rm -f $@
	@touch $@
	@echo 'set tool_root_dir   [pwd]'			>> $@
	@echo 'set tool            json'			>> $@
	@echo 'set srcdir          ./testsuite'			>> $@
	@echo 'set outdir          $$srcdir'			>> $@
	@echo 'set TOOL_EXECUTABLE $$tool_root_dir/$$tool'	>> $@

clean: CLEANFILES =				\
  json *.o					\
  json_parser.hh				\
  json_parser.cc				\
  json_parser.output				\
  json_parser.xml				\
  json_parser.html				\
  json_parser.gv				\
  json_parser.pdf				\
  json_scanner.cc				\
  site.exp
clean:
	rm -f $(CLEANFILES)
