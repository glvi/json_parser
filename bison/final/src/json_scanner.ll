%option noyywrap nounput
%option nodefault

%{
  #include "json_parser.hh"
  #include <sstream>
  #include <cstdint>
  auto make_STRING(std::string&&) -> yy::parser::symbol_type;
  auto illegal_character(char const *, int) -> yy::parser::syntax_error;
  auto make_NUMBER(char const *, int) -> yy::parser::symbol_type;
  auto make_UTF8(char const *, int) -> std::string;
  auto guard_CTRL(char) -> void;
%}

onenine      [1-9]
digit        [0-9]
positive     {onenine}{digit}*
negative     -{positive}
nonnegative  0|{positive}
integer      {nonnegative}|{negative}
fraction     \.{nonnegative}
exponent     [Ee][+-]?{nonnegative}
number       {integer}{fraction}?{exponent}?

unicode      \\u[0-9A-Fa-f]{4}

ws           [ \n\r\t]+

%x STRING

%%
                    std::string builder;

\x22                BEGIN(STRING); builder = "";
<STRING>\x22{2,}    throw yy::parser::syntax_error {"Too many \""};
<STRING>\x22        BEGIN(INITIAL); return make_STRING(std::move(builder));
<STRING>\\\"        builder += '\"';
<STRING>\\\\        builder += '\\';
<STRING>\\b         builder += '\b';
<STRING>\\f         builder += '\f';
<STRING>\\n         builder += '\n';
<STRING>\\r         builder += '\r';
<STRING>\\t         builder += '\t';
<STRING>{unicode}   builder += make_UTF8(yytext + 2, yyleng - 2);
<STRING>.|\n        guard_CTRL(yytext[0]); builder += yytext[0];

null     return yy::parser::make_NULL();
false    return yy::parser::make_FALSE();
true     return yy::parser::make_TRUE();

","      return yy::parser::make_COMMA();
":"      return yy::parser::make_COLON();
"["      return yy::parser::make_LSB();
"]"      return yy::parser::make_RSB();
"{"      return yy::parser::make_LCB();
"}"      return yy::parser::make_RCB();

{number} return make_NUMBER(yytext, yyleng);

{ws}     /* eat whitespace */

<<EOF>>  return yy::parser::make_YYEOF();

.        throw illegal_character(yytext, yyleng);

%%

char const * ctrl[] = {
  "<NUL>", "<SOH>", "<STX>", "<ETX>", "<EOT>", "<ENQ>", "<ACK>", "<BEL>",
  "<BS>" , "<HT>" , "<LF>" , "<VT>" , "<FF>" , "<CR>" , "<SO>" , "<SI>" ,
  "<DLE>", "<DC1>", "<DC2>", "<DC3>", "<DC4>", "<NAK>", "<SYN>", "<ETB>",
  "<CAN>", "<EM>" , "<SUB>", "<ESC>", "<FS>" , "<GS>" , "<RS>" , "<US>" ,
};

auto guard_CTRL(char c) -> void
{
  if (0 <= c and c < 0x20) {
    char const * str = ctrl[c];
    auto len = strlen(str);
    throw illegal_character(str, len);
  }
}

auto illegal_character(char const * str, int len) -> yy::parser::syntax_error
{
  std::string msg {"Illegal character: "};
  if (len == 1 && str[0] < 0x20) {
    msg += "u+";
  } else {
    msg.append(str, len);
  }
  throw yy::parser::syntax_error {msg};
}

auto make_NUMBER(char const * str, int) -> yy::parser::symbol_type
{
  std::istringstream in {str};
  double val;
  in >> val;
  if (not in) {
    std::string msg {"Unable to represent \""};
    msg.append(str);
    msg.append("\" as number");
    throw yy::parser::syntax_error {msg};
  }
  return yy::parser::make_NUMBER(JSONNumber {val});
}

auto make_STRING(std::string&& str) -> yy::parser::symbol_type
{
  return yy::parser::make_STRING(JSONString{std::move(str)});
}

std::string make_UTF8(uint16_t codepoint)
{
  std::string result;
  if (codepoint <= 0b0111'1111) {
    result.resize(1);
    result.data()[0] = static_cast<uint8_t>(codepoint);
  } else if (codepoint <= 0b0111'1111'1111) {
    result.resize(2);
    result.data()[1] = 0b1000'0000 | static_cast<uint8_t>(codepoint & 0b0011'1111);
    codepoint >>= 6;
    result.data()[0] = 0b1100'0000 | static_cast<uint8_t>(codepoint & 0b0001'1111);
  } else {
    result.resize(3);
    result.data()[2] = 0b1000'0000 | static_cast<uint8_t>(codepoint & 0b0011'1111);
    codepoint >>= 6;
    result.data()[1] = 0b1000'0000 | static_cast<uint8_t>(codepoint & 0b0011'1111);
    codepoint >>= 6;
    result.data()[0] = 0b1110'0000 | static_cast<uint8_t>(codepoint & 0b0000'1111);
  }
  return result;
}

auto make_UTF8(char const * ptr, int) -> std::string
{
  uint16_t const codepoint = strtoul(ptr, nullptr, 16);
  if (codepoint <= UINT16_MAX) {
    return make_UTF8(codepoint);
  } else {
    std::string msg {"Unicode codepoint out of range: "};
    msg.append(ptr);
    throw yy::parser::syntax_error {msg};
  }
}
