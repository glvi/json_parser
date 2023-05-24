# json_parser
Parser for JSON

I started this project for educational purposes.
I wanted to show-case how to write a parser using GNU bison.
And writing a JSON parser seemed like a good idea at the time.

# Dependencies
Mac,
Homebrew,
LLVM Clang,
GNU Bison,
GNU Flex,
GNU Make.

# Contents

The parser is in `json_parser.yy`.

The scanner is in `json_scanner.ll`.

The glue is in `json.cc/.hh`.

The executable is `json`.

The project is built using `Makefile`.

# Usage
The parser reads from standard input.
Messages are written to standard error.
```ShellSession
$ ./json < FILE
```

# Examples
For this input (`test1.json`):
```JavaScript
[null, true, false, 123, 123.456, "Fnord!\nHail\tEris!"]
```
this will happen:
```ShellSession
$ ./json < test1.json
I found JSON: [null, true, false, 123, 123.456, "Fnord!
Hail	Eris!"]
```
