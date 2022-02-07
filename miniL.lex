   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
   #include <stdio.h>
   #include "miniL-parser.h"
   int num_lines = 1;
   int num_cols = 1;
%}

   /* some common rules */
DIGIT     [0-9]
ID        [A-Za-z][A-Za-z0-9_]*[A-Za-z0-9]*
STARTD_ID  [0-9]+[A-Za-z_]+[A-Za-z0-9]*
STARTU_ID  [_]+[A-Za-z0-9_]*[A-Za-z0-9]*
END_ID    [A-Za-z][A-Za-z0-9_]*[_]+
%%
   /* specific lexer rules in regex */
" "            {++num_cols; }
"\t"           {num_cols += 4; }
"##".*         { /* DO NOTHING */ }           
\n             {++num_lines; num_cols = 0; }
"function"     {return FUNCTION; num_cols += yyleng; }
"beginparams"  {return BEGINPARAMS; num_cols += yyleng; }
"endparams"    {return ENDPARAMS; num_cols += yyleng; }
"beginlocals"  {return BEGINLOCALS; num_cols += yyleng; }
"endlocals"    {return ENDLOCALS; num_cols += yyleng; }
"beginbody"    {return BEGINBODY; num_cols += yyleng; }
"endbody"      {return ENDBODY; num_cols += yyleng; }
"integer"      {return INTEGER; num_cols += yyleng; }
"array"        {return ARRAY; num_cols += yyleng; }
"of"           {return OF; num_cols += yyleng; }
"if"           {return IF; num_cols += yyleng; }
"then"         {return THEN; num_cols += yyleng; }
"endif"        {return ENDIF; num_cols += yyleng; }
"else"         {return ELSE; num_cols += yyleng; }
"while"        {return WHILE; num_cols += yyleng; }
"do"           {return DO; num_cols += yyleng; }
"beginloop"    {return beginloop; num_cols += yyleng; }
"endloop"      {return endloop; num_cols += yyleng; }
"continue"     {return continue; num_cols += yyleng; }
"break"        {return break; num_cols += yyleng; }
"read"         {return read; num_cols += yyleng; }
"write"        {return write; num_cols += yyleng; }
"not"          {return not; num_cols += yyleng; }
"true"         {return true; num_cols += yyleng; }
"false"        {return false; num_cols += yyleng; }
"return"       {return return; num_cols += yyleng; }

"-"            {return '-'; num_cols += yyleng; }
"+"            {return '+'; num_cols += yyleng; }
"*"            {return '*'; num_cols += yyleng; }
"/"            {return '/'; num_cols += yyleng; }
"%"            {return '%'; num_cols += yyleng; }

"=="           {return "=="; num_cols += yyleng; }
"<>"           {return "<>"; num_cols += yyleng; }
"<"            {return '<'; num_cols += yyleng; }
">"            {return '>'; num_cols += yyleng; }
"<="           {return "<="; num_cols += yyleng; }
">="           {return ">="; num_cols += yyleng; }

";"            {return ';'; num_cols += yyleng; }
":"            {return ':'; num_cols += yyleng; }
","            {return ','; num_cols += yyleng; }
"("            {return '('; num_cols += yyleng; }
")"            {return ')'; num_cols += yyleng; }
"["            {return '['; num_cols += yyleng; }
"]"            {return ']'; num_cols += yyleng; }
":="           {return ":="; num_cols += yyleng; }

{STARTD_ID}    {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", num_lines, num_cols, yytext); exit(1); }
{STARTU_ID}    {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", num_lines, num_cols, yytext); exit(1); }
{END_ID}       {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", num_lines, num_cols, yytext); exit(1); }
{ID}           { yylval.sval = strdup(yytext); num_cols += yyleng; return identifier; }    //printf("IDENT %s\n", yytext);
{DIGIT}+       { yylval.ival = atoi(yytext); num_cols += yyleng; return NUMBER; }          //printf("NUMBER %s\n", yytext)

.              {++num_cols; printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", num_lines, num_cols, yytext); exit(1); }

%%