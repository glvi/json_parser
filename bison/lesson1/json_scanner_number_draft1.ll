natural    0|[1-9][0-9]*
integer    -?{natural}
fraction   \.{natural}
exponent   [Ee][+-]?{natural}
number     {integer}{fraction}?{exponent}?
%%
{number}   return /* NUMBER token */
