/* -*- mode: antlr; coding: utf-8; indent-tabs-mode: nil; -*- */

grammar json;

json: element ;

value: object | array | string | number | 'true' | 'false' | 'null' ;

object: '{' ws '}' | '{' members '}' ;

members: member | member ',' members ;

member: ws string ws ':' element ;

array: '[' ws ']' | '[' elements ']' ;

elements: element | element ',' elements ;

element: ws value ws ;

string: '"' characters '"' ;

characters: | Character characters ;

Character: ~[\u0000-\u001f\u0022\u005c] ;

escape: '"' | '\\' | '/' | 'b' | 'f' | 'n' | 'r' | 't' | ('u' Hex Hex Hex Hex) ;

Hex: Digit | [a-f] | [A-F] ;

number: integer fraction exponent ;

integer: Digit | Onenine digits | '-' Digit | '-' Onenine digits ;

digits: Digit | digits Digit ;

Digit: '0' | Onenine ;

Onenine: [1-9] ;

fraction: | '.' digits ;

exponent: | 'E' sign digits | 'e' sign digits ;

sign: | '+' | '-' ;

ws: | '\u0009' ws | '\u000a' ws | '\u000d' ws | '\u0020' ws ;
