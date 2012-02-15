%{
	#include <stdio.h>
	extern int yylex();
	void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}
%union{
	char *id;
}

/* keywords */
%token CLASS /* class" */
%token PUBLIC /* public */
%token STATIC /* static */
%token LENGTH /* length */
%token RETURN /* return */
%token IF /* if */
%token ELSE /* else */
%token WHILE /* while */
%token NEW /* new */
%token THIS /* this */
%token SYSO /* System.out.println */

/* types */
%token VOID /* void */
%token INT /* int */
%token BOOL /* boolean */
%token STRING /* String */

/* boolean values */
%token TRUE /* true */
%token FALSE /* false */

/* operators */
/* precedence taken from http://docs.oracle.com/javase/tutorial/java/nutsandbolts/operators.html */
%left DISJ /* || */
%left CONJ /* && */
%left EQUAL NEQUAL /* == != */
%left LESS GREATER LEQ GEQ /* < > <= >= */
%left PLUS MINUS /* + - */
%left MULT /* * */
%left NOT /* ! */

/* symbols */
%token LBLOCK /* { */
%token RBLOCK /* } */
%token LPAREN /* ( */
%token RPAREN /* ) */
%token LBRACK /* [ */
%token RBRACK /* ] */
%token SCOLON /* ; */
%token COMMA /* , */
%token PERIOD /* . */

/* identifier/numbers */
%token <id> id
%token <id> int_lit

%start Program

%%

Program: MainClass ClassList {puts("Program");}

MainClass: CLASS id LBLOCK PUBLIC STATIC VOID id LPAREN STRING LBRACK RBRACK id LBLOCK VarList StmtList {puts("MainClass");}

ClassList: ClassList ClassDecl
	| /* empty */

ClassDecl: CLASS id LBLOCK VarList MethodList RBLOCK {puts("ClassDecl");}

VarList: VarList VarDecl
	| /* empty */

VarDecl: Type id SCOLON {puts("VarDecl");}

MethodList: MethodList MethodDecl
	| /* empty */

MethodDecl: PUBLIC Type id LPAREN FormalList RPAREN LBLOCK VarList StmtList RETURN Exp SCOLON RBLOCK {puts("VarDecl");}

FormalList: Type id FormalRest {puts("FormalList");}
	| /* empty */

FormalRest: FormalRest COMMA Type id {puts("FormalRest");}
	| /* empty */

Type: INT LBRACK RBRACK {puts("Type:INT[]");}
	| BOOL {puts("Type:BOOL");}
	| INT {puts("Type:INT");}
	| id {puts("Type:id");}

StmtList: StmtList Stmt
	| /* empty */

Stmt: LBLOCK StmtList RBLOCK {puts("Stmt:{Stmt*}");}
	| IF LPAREN Exp RPAREN Stmt ELSE Stmt {puts("Stmt:if-else");}
	| WHILE LPAREN Exp RPAREN Stmt {puts("Stmt:while");}
	| SYSO LPAREN Exp RPAREN SCOLON {puts("Stmt:SYSO");}

Exp: Exp Op Exp {puts("Exp:ExpOpExp");}
	| Exp LBRACK Exp RBRACK {puts("Exp:Exp[Exp]");} // What should this do?
	| Exp PERIOD LENGTH {puts("Exp:Exp.length");}
	| Exp PERIOD id LPAREN ExpList RPAREN {puts("Exp:Exp.id(..)");}
	| int_lit {puts("Exp:int_lit");}
	| TRUE {puts("Exp:true");}
	| FALSE {puts("Exp:false");}
	| id {puts("Exp:id");}
	| THIS {puts("Exp:this");}
	| NEW INT LBRACK Exp RBRACK {puts("Exp:newint[]");}
	| NEW id LPAREN RPAREN {puts("Exp:newid()");}
	| NOT Exp {puts("Exp:!Exp");}
	| LPAREN Exp RPAREN {puts("Exp:(Exp)");}

Op: CONJ {puts("Exp:&&");}
	| LESS {puts("Exp:<");}
	| PLUS {puts("Exp:+");}
	| MINUS {puts("Exp:-");}
	| MULT {puts("Exp:*");}

ExpList: Exp ExpRestList {puts("ExpList");}
	| /* empty */

ExpRestList: ExpRestList ExpRest
	| /* empty */

ExpRest: COMMA Exp {puts("ExpRest");}

