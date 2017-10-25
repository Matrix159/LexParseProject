%{

#include <stdio.h>
#include "zoomjoystrong.h"
void yyerror(const char* s);
%}

%union {
  int iVal;
  float fVal;
  char* sVal;
}

%start program

%token END
%token END_STATEMENT
%token <sVal> POINT
%token <sVal> LINE
%token <sVal> CIRCLE
%token <sVal> RECTANGLE
%token <sVal> SET_COLOR
%token <iVal> INT
%token <fVal> FLOAT


%%
program: statement_list end_command;
statement_list: statement
		| statement statement_list
		;
statement: command END_STATEMENT;
command: LINE INT INT INT INT { line($2, $3, $4, $5); }
	| POINT INT INT { point($2, $3); }
	| CIRCLE INT INT INT { circle($2, $3, $4); }
	| RECTANGLE INT INT INT INT { rectangle($2, $3, $4, $5); }
	| SET_COLOR INT INT INT { checkValidColor($2, $3, $4); }
	;
end_command: END END_STATEMENT;
%%

int main(int arc, char** argv){
setup();
yyparse();

finish();
return 0;
}

/**
* Check if the values are valid rgb and call set_color function if
* they are and return 1, else return 0 for invalid rgb.
* @param r Red
* @param g Green
* @param b Blue
* @return 1 if valid colors, 0 otherwise
*/
int checkValidColor(int r, int g, int b) {

    if((r >= 0 && r <= 255) && (g >= 0 && g <= 255) && (b >= 0 && b <= 255) }
        set_color(r, g, b);
	return 1;
    } else {
        return 0;
    }
}

void yyerror(const char* s) {

fprintf(stderr, "%s\n", s);
}

