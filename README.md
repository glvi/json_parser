# json_parser

Parser for JSON

I started this project for educational purposes.
I wanted to show-case how to write a parser using GNU bison.
And writing a JSON parser seemed like a good idea at the time.
Then I wanted to compare this to writing a parser using [ANTLR](https://www.antlr.org).

**GNU Bison References**:

- See https://www.gnu.org/software/bison.

**ANTLR References**:

- See https://www.antlr.org/.

**JSON References**:

- Bray, T., Ed., "The JavaScript Object Notation (JSON) Data Interchange Format", STD 90, RFC 8259, DOI 10.17487/RFC8259, December 2017, <https://www.rfc-editor.org/info/rfc8259>.
- Ecma International, "The JSON Data Interchange Format", Standard ECMA-404, <http://www.ecma-international.org/publications/standards/Ecma-404.htm>.
- See also: https://json.org/.

**On Compilers**:

- Stanford's course in the practical and theoretical aspects of compiler construction (CS143 Compilers) web page: <https://web.stanford.edu/class/archive/cs/cs143/cs143.1128/>.

# Structure

Directories `bison` and `antlr` hold the distinct experiments on how to write a JSON parser using either parser generator.

Directory `common` holds code that is shared between all experiments, namely the C++ representation of a JSON value.

Directories `bison/lesson<N>` hold the distinct lessons on how to write a JSON parser using GNU's Bison and Flex.

Directory `bison/final` holds the final result using GNU's Bison and Flex.
