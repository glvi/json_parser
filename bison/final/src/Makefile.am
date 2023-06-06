BUILT_SOURCES    = json_parser.hh
bin_PROGRAMS     = json
json_SOURCES     = json.cc json.hh json_parser.yy json_scanner.ll
CLEANFILES       = json_parser.cc json_parser.hh json_scanner.cc

# Override autoconf default rule, because it sucks
%.cc %.hh: %.yy
	$(AM_V_YACC)$(am__skipyacc) $(YACC) -o$*.cc -H$*.hh $<
