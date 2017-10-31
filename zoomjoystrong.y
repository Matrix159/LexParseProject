%{

#include <stdio.h>
#include "zoomjoystrong.h"
extern int yylineno;

int yylex();
void doPoint(int one, int two);
void doCircle(int one, int two, int three);
void doRectangle(int one, int two, int three, int four);
void doLine(int one, int two, int three, int four);
void checkValidColor(int r, int g, int b);
int checkValues(int x, int y);
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
command: LINE INT INT INT INT { doLine($2, $3, $4, $5); }
	| POINT INT INT { doPoint($2, $3); }
	| CIRCLE INT INT INT { doCircle($2, $3, $4); }
	| RECTANGLE INT INT INT INT { doRectangle($2, $3, $4, $5); }
	| SET_COLOR INT INT INT { checkValidColor($2, $3, $4); }
	;
end_command: END END_STATEMENT;
%%

/**
* Start of the parser obviously
*/
int main(int arc, char** argv){

    setup();
    yyparse();
    finish();
    return 0;
}

/**
* Draws a line but adds validation to x, y coordinates
* @param one The X coordinate
* @param two The Y coordinate
* @param three X coordinate of end of line
* @param four Y coordinate of end of line 
*/
void doLine(int one, int two, int three, int four) {

    if(checkValues(one, two) == 1) {
        line(one, two, three, four);
    }
}

/**
* Draws a point but with validation
* @param one X coordinate
* @param two Y coordinate
*/
void doPoint(int one, int two) {

    if(checkValues(one, two) == 1) {
	point(one, two);
    }
}

/**
* Draws a circle with validation
* @param one X coordinate of circle
* @param two Y coordinate of circle
* @param three The size of the circle
*/
void doCircle(int one, int two, int three) {

    if(checkValues(one, two) == 1) {
	circle(one, two, three);
    }
}

/**
* Draws a rectangle with validation
* @param one The X coordinate
* @param two The Y coordinate 
* @param three The width of the rectangle
* @param four The height of the rectangle
*/
void doRectangle(int one, int two, int three, int four) {

    if(checkValues(one, two) == 1) {
	rectangle(one, two, three, four);
    }
}

/**
* Check if the values are valid rgb and call set_color function if
* they are and return 1, else return 0 for invalid rgb.
* @param r Red
* @param g Green
* @param b Blue
*/
void checkValidColor(int r, int g, int b) {

    if((r >= 0 && r <= 255) && (g >= 0 && g <= 255) && (b >= 0 && b <= 255)) {
        set_color(r, g, b);
    } else {
        fprintf(stderr, "Invalid color found.\n");
    }
}

/**
* Check for valid coordinate values that between 0 <= Width And Height
* @param x First value to check
* @param y Second value to check
* @return 1 if valid, 0 otherwise
*/
int checkValues(int x, int y) {

    if(x < 0 || x > WIDTH || y < 0 || y > HEIGHT) {
	fprintf(stderr, "Bad coordinates found\n");
        return 0;
    } else {
	return 1;
    }
}

void yyerror(const char* s) {

    fprintf(stderr, "%s\n", s);
}

