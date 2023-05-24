# json_parser

Parser for JSON

I started this project for educational purposes.
I wanted to show-case how to write a parser using GNU bison.
And writing a JSON parser seemed like a good idea at the time.

# Dependencies

## Operating system(s)

Tested on macOS 13.3.1 with support from [Homebrew](https://brew.sh/)

## Compiler(s)

Tested with LLVM 16.0 Clang and GNU G++ 13.1

```ShellSession
$ brew install llvm # or
$ brew install gcc # or both
```

## Parser and scanner generators

Tested with GNU Bison 3.8.2 and GNU Flex 2.6.4

```ShellSession
$ brew install bison # and
$ brew install flex
```

## Build tool

Tested with GNU Make 4.4.1.

```ShellSession
$ brew install make
```

# Contents

The parser is in `json_parser.yy`.

The scanner is in `json_scanner.ll`.

The glue is in `json.cc/.hh`.

The executable is `json`.

The project is built using `Makefile`.

# Building

```ShellSession
$ gmake
```

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
