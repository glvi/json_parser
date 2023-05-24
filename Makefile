# -*- mode: makefile-gmake; coding: utf-8; -*-

BISON=/usr/local/opt/bison/bin/bison
CXX=/usr/local/opt/gcc/bin/g++-13
FLEX=/usr/local/opt/flex/bin/flex
DOT=/usr/local/bin/dot

CXXFLAGS=-std=c++20

all: json json_parser.pdf

%.cc %.hh %.html %.gv: %.yy
	$(BISON) $(BISONFLAGS) --html --graph -o $*.cc $<

%.pdf: %.gv
	$(DOT) -Tpdf -o$@ $<

%.cc: %.ll
	$(FLEX) $(FLEXFLAGS) -o$@ $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o$@ $<

json: json.o json_parser.o json_scanner.o
	$(CXX) -o $@ $^

json.o: json_parser.hh
json_parser.o: json_parser.hh
json_scanner.o: json_parser.hh

run: json
	./$< < test1.json
	echo '[{"key": "value", "stuff": ["this", "and", "\\"that\\""]}]' | ./$<
	echo '{"Shiba Inu": "柴犬"}' | ./$<
	echo '["\\u003a", "\\u00a3", "\\u2207"]' | ./$<
	echo '["\\b\\f\\g\\n\\r\\t"]' | ./$<
	-./$< < /dev/null
	-echo ']' | ./$<
	-echo '}' | ./$<
	-echo '+123' | ./$<
	-echo '123.' | ./$<
	-echo '"\000"' | ./$<
	-echo '"\001"' | ./$<
	-echo '"\002"' | ./$<
	-echo '"\003"' | ./$<
	-echo '"\004"' | ./$<
	-echo '"\005"' | ./$<
	-echo '"\006"' | ./$<
	-echo '"\007"' | ./$<
	-echo '"\010"' | ./$<
	-echo '"\011"' | ./$<
	-echo '"\012"' | ./$<
	-echo '"\013"' | ./$<
	-echo '"\014"' | ./$<
	-echo '"\015"' | ./$<
	-echo '"\016"' | ./$<
	-echo '"\017"' | ./$<
	-echo '"\020"' | ./$<
	-echo '"\021"' | ./$<
	-echo '"\022"' | ./$<
	-echo '"\023"' | ./$<
	-echo '"\024"' | ./$<
	-echo '"\025"' | ./$<
	-echo '"\026"' | ./$<
	-echo '"\027"' | ./$<
	-echo '"\030"' | ./$<
	-echo '"\031"' | ./$<
	-echo '"\032"' | ./$<
	-echo '"\033"' | ./$<
	-echo '"\034"' | ./$<
	-echo '"\035"' | ./$<
	-echo '"\036"' | ./$<
	-echo '"\037"' | ./$<

clean: CLEANFILES =					\
  json *.o					        \
  json_parser.hh					\
  json_parser.cc					\
  json_parser.output					\
  json_parser.xml					\
  json_parser.html					\
  json_parser.gv					\
  json_parser.pdf					\
  json_scanner.cc
clean:
	rm -f $(CLEANFILES)
