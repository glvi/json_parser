%skeleton "lalr1.cc" // -*- C++ -*-
%require "3.8.2"
%header

%define api.token.raw
%define api.token.constructor
%define api.value.type variant
%define api.value.automove
%define parse.assert

%code requires {
  #include "json.hh"
  struct Driver {
    std::optional<JSONValue> result;
  };
  #define YY_DECL auto yylex(Driver& driver) -> yy::parser::symbol_type
}

%define parse.trace
%define parse.error detailed
%define parse.lac full

%code {
  YY_DECL;
}

%param { Driver& driver }

%define api.token.prefix {TOK_JSON_}
%token
  NULL   "null"
  TRUE   "true"
  FALSE  "false"
  COMMA  ","                    // U+002C comma
  COLON  ":"                    // U+003A colon
  LSB    "["                    // U+005B left square bracket
  RSB    "]"                    // U+005D right square bracket
  LCB    "{"                    // U+007B left curly bracket
  RCB    "}"                    // U+007D right curly bracket
;

%code requires {
  using std::string;
}

%code {
  template<typename T>
    static constexpr bool const is_parser_type_v =
    std::is_default_constructible_v<T> and
    (std::is_move_assignable_v<T> or
     std::is_copy_assignable_v<T>);

  static_assert(is_parser_type_v<double>);
  static_assert(is_parser_type_v<string>);
  static_assert(is_parser_type_v<JSONNull>);
  static_assert(is_parser_type_v<JSONBoolean>);
  static_assert(is_parser_type_v<JSONNumber>);
  static_assert(is_parser_type_v<JSONString>);
  static_assert(is_parser_type_v<JSONArray>);
  static_assert(is_parser_type_v<JSONObject>);
  static_assert(is_parser_type_v<JSONValue>);
}

%token <double>      NUMBER "number"
%token <string>      STRING "string"

%nterm <JSONString>  string
%nterm <JSONArray>   array
%nterm <JSONArray>   values;
%nterm <JSONObject>  mappings
%nterm <JSONObject>  object
%nterm <JSONValue>   simple
%nterm <JSONValue>   value;

%start start;

%%

start:
  value { driver.result = $1; }
;

value:
  simple { $$ = $1; }
| object { $$ = $1; }
| array  { $$ = $1; }
;

simple:
  "null"   { $$ = JSON_NULL; }
| "false"  { $$ = JSON_FALSE; }
| "true"   { $$ = JSON_TRUE; }
| "number" { $$ = JSONNumber {$1}; }
| string   { $$ = $1; }
;

object:
  "{" "}"          { $$ = JSONObject {}; }
| "{" mappings "}" { $$ = $2; }
;

array:
  "[" "]"        { $$ = JSONArray {}; }
| "[" values "]" { $$ = $2; }
;

mappings:
  string ":" value {$$ = JSONObject {$1, $3};}
| mappings "," string ":" value {
    $1.emplace($3, $5); $$ = $1;}
;

values:
  value { $$ = JSONArray {$1}; };
| values "," value { $1.push_back($3); $$ = $1; }
;

string:
  "string" { $$ = JSONString {$1}; }
;

%%

namespace yy {
  auto parser::error(string const& text) -> void
  {
    std::clog << text << "\n";
  }
}
