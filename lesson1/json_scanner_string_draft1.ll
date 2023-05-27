%x STRING
%%
\"         BEGIN(STRING);
<STRING>\" BEGIN(INITIAL); return /* STRING token */;
<STRING>.  yymore();
