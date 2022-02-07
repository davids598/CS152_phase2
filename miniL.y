    /* cs152-miniL phase2 */
%{
extern int yylex();
extern int yyparse();
void yyerror(const char *msg);
%}

%union{
  /* put your types here */
  int ival;
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

%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE BREAK READ WRITE
%token NOT TRUE FALSE RETURN EQUALITY NOT_EQ LESS_EQ GTR_EQ ASSIGN ERROR
%token <ival> NUMBER
%token <sval> IDENT

/* %start program */

%% 

  /* write your rules here */
  prog_start: functions {printf("prog_start -> functions\n");}
  ;

  functions: Function functions {printf("functions -> function functions\n");}
  |
  ;

  Function: FUNCTION IDENT ';' BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY {printf("function -> IDENT ';' beginparams declarations endparams beginlocals declarations endlocals beginbody statements endbody\n");}
  ;

  declarations: declaration ';' declarations {printf("declarations -> declaration ';' declarations\n");}
  |
  ;

  declaration: IDENT ':' INTEGER                      {printf("declaration -> IDENT %s ':' integer\n", $1);}
  | IDENT ':' ARRAY '[' NUMBER ']' OF INTEGER         {printf("declaration -> IDENT %s ':' array '[' NUMBER %d ']' of integer\n", $1, $5);}
  ;

  expression : mult-expr                            {printf("expression -> mult-expr\n");}
             | mult-expr '+'  expression             {printf("expression -> mult-expr '+'  expression\n");}
             | mult-expr '-' expression             {printf("expression -> mult-expr '-' expression\n");}
             ;

  statements: statement ';' statements                {printf("statements -> statement ';' statements\n");}
  |
  ;

  statement : var ASSIGN expression                                     {printf("statement -> var ASSIGN expression\n");}
            | IF bool-exp THEN statements ENDIF                         {printf("statement -> if bool-exp then statements endif\n");}
            | IF bool-exp THEN statements ELSE statements ENDIF         {printf("statement -> if bool-exp then statements else statements endif\n");}
            | WHILE bool-exp BEGINLOOP statements ENDLOOP               {printf("statement -> while bool-exp beginloop statements endloop\n");}
            | DO BEGINLOOP statements ENDLOOP WHILE bool-exp            {printf("statement -> do beginloop statements endloop while bool-exp\n");}
            | READ var                                                  {printf("statement -> read var\n");}
            | WRITE var                                                 {printf("statement -> write var\n");}
            | CONTINUE                                                  {printf("statement -> continue\n");}
            | BREAK                                                     {printf("statement -> break\n");}
            | RETURN expression                                         {printf("statement -> return expression\n");}
  ;

  bool-exp : expression comp expression                             {printf("bool-exp -> expression comp expression\n");}
           | NOT expression comp expression                         {printf("bool-exp -> not expression comp expression\n");}
  ;

  comp : EQUALITY                                                       {printf("comp -> EQUALITY\n");}
  |      NOT_EQ                                                         {printf("comp -> NOT_EQ\n");}
  |       '<'                                                           {printf("comp -> '<'\n");}
  |       '>'                                                           {printf("comp -> '>'\n");}
  |       LESS_EQ                                                       {printf("comp -> LESS_EQ\n");}
  |       GTR_EQ                                                        {printf("comp -> GTR_EQ\n");}
  ;

  mult-expr : term                                                      {printf("mult-expr -> term\n");}
            | term '*' mult-expr                                          {printf("mult-expr -> term '*' mult-expr\n");}
            | term '/' mult-expr                                          {printf("mult-expr -> term '/' mult-expr\n");}
            | term '%' mult-expr                                          {printf("mult-expr -> term '%' mult-expr\n");}
            ;

  term : var                                                            {printf("term -> var\n");}
       | NUMBER                                                         {printf("term -> NUMBER %d\n", $1);}
       | '(' expression ')'                                             {printf("term -> '(' expression ')' \n");}
       | IDENT '(' expression ')'                                       {printf("term -> IDENT %s '(' expression ')' \n", $1);}
       ;

  var : IDENT                                                           {printf("var -> IDENT %s\n", $1);}
      | IDENT '[' expression ']'                                        {printf("var -> IDENT %s '[' expression ']' \n", $1);}
      |
      ;


%% 

int main(int argc, char **argv) {
   yyparse();
   return 0;
}

void yyerror(const char *msg) {
    /* implement your error handling */
    extern int num_lines;
    printf("Line %d: %s\n", num_lines, msg);
}