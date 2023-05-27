%%

value: "null" | "true" | "false" | number | string | object | array;

object: "{" "}" | "{" mappings "}";

mappings: string ":" value | mappings "," string ":" value;

array: "[" "]" | "[" values "]";

values: value | values "," value;
