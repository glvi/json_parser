%token <double> NUMBER;
%token <string> STRING;

%%

value: "null" | "true" | "false" | NUMBER | STRING | object | array;

object: "{" "}" | "{" mappings "}";

mappings: STRING ":" value | mappings "," STRING ":" value;

array: "[" "]" | "[" values "]";

values: value | values "," value;
