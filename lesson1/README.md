html header:	<link rel="stylesheet" href="http://yandex.st/highlightjs/7.3/styles/default.min.css">
	<script src="http://yandex.st/highlightjs/7.3/highlight.min.js"></script>
	<script>hljs.initHighlightingOnLoad();</script>

# Lesson 1 "What does the grammar look like?"

The JavaScript Object Notation (JSON) grammar has a very succinct structure:

The content of a buffer, or file, or stream, containing JSON-structured data is always only a single JSON value.

This JSON value shall be either

- a literal `null`,
- a literal `true`,
- a literal `false`,
- a number,
- a string,
- an object, or
- an array;

where

- a JSON object contains zero or more mappings of the kind "string: value" between curly brackets "{…}"; and
- a JSON array contains zero or more values between square brackets "[…]".

The initial grammar draft looks thusly:

```bison
{{json_parser_draft1.yy}}
```

Generating the parser produces errors, because the symbols `number`
and `string` haven't been defined.

```ShellSession
$ bison json_parser_draft.yy
json_parser.yy:3.36-41: symbol number is used, but is not defined as a token and has no rules
json_parser.yy:3.45-50: symbol string is used, but is not defined as a token and has no rules
```

JSON numbers can be obtained from the scanner with the following
regular expressions.

```flex
{{json_scanner_number_draft1.ll}}
```

JSON strings are a bit more involved, but can also be obtained from
the scanner.

The following is a draft set of lexer patterns and actions for
matching a string enclosed in double quotes.

```flex
{{json_scanner_string_draft1.ll}}
```

The updated grammar draft then looks thusly:

```bison
{{json_parser.yy}}
```

**References**:
- Bray, T., Ed., "The JavaScript Object Notation (JSON) Data Interchange Format", STD 90, RFC 8259, DOI 10.17487/RFC8259, December 2017, <https://www.rfc-editor.org/info/rfc8259>.
- Ecma International, "The JSON Data Interchange Format", Standard ECMA-404, <http://www.ecma-international.org/publications/standards/Ecma-404.htm>.
- See also: https://json.org/.
