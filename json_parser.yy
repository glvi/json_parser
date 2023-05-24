%skeleton "lalr1.cc" // -*- C++ -*-
%require "3.8.2"
%header

%define api.token.raw
%define api.token.constructor
%define api.value.type variant
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
  LCB    "{"                    // U+007B left curly bracket
  RCB    "}"                    // U+007D right curly bracket
  LSB    "["                    // U+005B left square bracket
  RSB    "]"                    // U+005D right square bracket
  COMMA  ","                    // U+002C comma
  COLON  ":"                    // U+003A colon
;

%code {
  template<typename T>
    static constexpr bool const is_parser_type_v =
    std::is_default_constructible_v<T> and
    (std::is_move_assignable_v<T> or
     std::is_copy_assignable_v<T>);

  static_assert(is_parser_type_v<double>);
  static_assert(is_parser_type_v<std::string>);
  static_assert(is_parser_type_v<JSONNull>);
  static_assert(is_parser_type_v<JSONBoolean>);
  static_assert(is_parser_type_v<JSONNumber>);
  static_assert(is_parser_type_v<JSONString>);
  static_assert(is_parser_type_v<JSONArray>);
  static_assert(is_parser_type_v<JSONObject>);
  static_assert(is_parser_type_v<JSONValue>);
}

%token <double>       NUMBER "number"
%token <std::string>  STRING "string"

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
  value { driver.result = std::move($1); }
;

value:
  simple { $$ = std::move($1); }
| object { $$ = std::move($1); }
| array  { $$ = std::move($1); }
;

simple:
  "null"   { $$ = JSON_NULL; }
| "false"  { $$ = JSON_FALSE; }
| "true"   { $$ = JSON_TRUE; }
| "number" { $$ = JSONNumber {$1}; }
| string   { $$ = std::move($1); }
;

object:
  "{" "}"          { $$ = JSONObject {}; }
| "{" mappings "}" { $$ = std::move($2); }
;

array:
  "[" "]"        { $$ = JSONArray {}; }
| "[" values "]" { $$ = std::move($2); }
;

mappings:
  string ":" value {$$ = JSONObject {std::move($1), std::move($3)};}
| mappings "," string ":" value {
    $1.emplace(std::move($3), std::move($5)); $$ = std::move($1);}
;

values:
  value { $$ = JSONArray {std::move($1)}; };
| values "," value { $1.push_back(std::move($3)); $$ = std::move($1); }
;

string:
  "string" { $$ = JSONString {std::move($1)}; }
;

%%

namespace yy {
  auto parser::error(std::string const& text) -> void
  {
    std::clog << text << "\n";
  }
}
