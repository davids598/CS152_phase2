    /* cs152-miniL phase2 */
%{
void yyerror(const char *msg);
%}

%union{
  /* put your types here */
  int ival;
  string *strval;
  char *sval;
}

%error-verbose
%locations

/* Lower Precdence */

%left '+' '-'       /* (A op B) op C  */
%left '*' '/'       /* A op (B op C)   */
%right '='          /* A = (B = C)     */

/* Higher precedence */

%start prog_start

%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO beginloop endloop continue break read write
%token not true false return 
%token <ival> NUMBER
%token <sval> IDENT

/* %start program */

%% 

  /* write your rules here */
  prog_start: functions {printf("prog_start -> functions")};
  |
  ;

  functions: FUNCTION functions {printf("functions -> function functions")};
  |
  ;

  Function: FUNCTION IDENT ';' BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY {printf("function -> IDENT ';' beginparams declarations endparams beginlocals declarations endlocals beginbody statements endbody")};
  |
  ;

  declarations: declaration ';' declarations {printf("declarations -> declaration ';' declarations")};
  |
  ;

  declaration: IDENT ':' INTEGER                      {printf("declaration -> IDENT ':' integer")};
  | IDENT ':' ARRAY '[' NUMBER ']' OF INTEGER         {printf("declaration -> IDENT ':' array '[' NUMBER ']' of integer")};
  |
  ;

  expression : mult-expr                            {printf("expression -> mult-expr")};
             | mult-expr '+'  expression             {printf("expression -> mult-expr '+'  expression")};
             | mult-expr '-' expression             {printf("expression -> mult-expr '-' expression")};
             ;

  statements: statement ';' statements                {printf("statements -> statement ';' statements")};
  |
  ;

  statement : var ":=" expression                                       {printf("statement -> var ":=" expression")};
            | IF bool-exp THEN statements ENDIF                         {printf("statement -> if bool-exp then statements endif")};
            | IF bool-exp THEN statements ELSE statements ENDIF         {printf("statement -> if bool-exp then statements else statements endif")};
            | WHILE bool-exp beginloop statements endloop               {printf("statement -> while bool-exp beginloop statements endloop")};
            | DO beginloop statements endloop WHILE bool-exp            {printf("statement -> do beginloop statements endloop while bool-exp")};
            | read var                                                  {printf("statement -> read var")};
            | write var                                                 {printf("statement -> write var")};
            | continue                                                  {printf("statement -> continue")};
            | break                                                     {printf("statement -> break")};
            | return expression                                         {printf("statement -> return expression")};
  |
  ;

  bool-exp : expression comp expression                             {printf("bool-exp -> expression comp expression")};
           | not expression comp expression                         {printf("bool-exp -> not expression comp expression")};
  ;

  comp : "=="                                                           {printf("comp -> \"==\"")};
  |      "<>"                                                           {printf("comp -> \"<>\"")};
  |       '<'                                                           {printf("comp -> '<'")};
  |       '>'                                                           {printf("comp -> '>'")};
  |       "<="                                                          {printf("comp -> \"<=\"")};
  |       ">="                                                          {printf("comp -> \">=\"")};
  |
  ;

  mult-expr : term                                                      {printf("mult-expr -> term")};
            | term '*' mult-expr                                          {printf("mult-expr -> term '*' mult-expr")};
            | term '/' mult-expr                                          {printf("mult-expr -> term '/' mult-expr")};
            | term '%' mult-expr                                          {printf("mult-expr -> term '%' mult-expr")};
            ;

  term : var                                                            {printf("term -> var")};
       | NUMBER                                                         {printf("term -> NUMBER")};
       | '(' expression ')'                                             {printf("term -> '(' expression ')' ")};
       | IDENT '(' expression ')'                                       {printf("term -> IDENT '(' expression ')' ")};
       ;

  var : IDENT                                                           {printf("var -> IDENT")};
      | IDENT '[' expression ']'                                        {printf("var -> IDENT '[' expression ']' ")};
      |
      ;


%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    printf("** Line %d: %s\n", lineno, msg);
}