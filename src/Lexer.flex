import java.io.*;

%%

%{

public int[][] id = new int[10][10];
public String[][] idText = new String[10][10];
public int escopo = 0;
public int lines = 0;
public int lastId = 0;
public boolean type = false;
public boolean definedVarOrFunc = false;
public boolean isFunction = false;
public boolean isFor = false;
public boolean changeContext = true;

public static void main(String[] args)
{
    final String path = "../code.txt";

    try {
        String content = new FileHandler().read(path);
        Reader reader = new StringReader(content);
        Lexer lexer = new Lexer(reader);

        lexer.yylex();
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
}

%}

%class Lexer
%unicode
%type Integer

NEWLINE=\r\n|\r|\n
WORD=[A-Za-z_][A-Za-z_0-9]*
ARRAY=\[([^\]]*)\]
SPACE=[\n\r\ \t\b\012]
VARIABLE={WORD}
STRING=\"([^\\\"]|\\.)*\"
DIGIT_INT=[0-9]+
DIGIT_FLOAT={DIGIT_INT}\.{DIGIT_INT}
DIGIT={DIGIT_INT}|{DIGIT_FLOAT}
TYPES=void|float|int|char|string|double|short|signed|unsigned|long
RESERVED_WORD=#define|#include|clrscr|do|while|for|break|continue|switch|case|default|goto|printf|getch|scanf|if|else|return|NULL|null|asm|auto|const|static|sizeof|typedef|struct
HEADER_FILE=<{WORD}\.h>
COMMENT=(\/\/[^\r\n|\r|\n]*)|(\/\*([^\*]|\*+[^\*\/])*\*+\/)

RELATIONAL_OP="!="|"<"|"<="|"=="|">="|">"
LOGICAL_OP="||"|&&
ARITH_OP="++"|"+"|"-"|"*"|"/"

EQUAL==
COMMA=,
SEMICOLON=;
AMP="&"
L_BRACKET="{"
R_BRACKET="}"
L_PAREN="("
R_PAREN=")"
L_SQ_BRACKET="["
R_SQ_BRACKET="]"

%%

/* Remoção de linhas e comentários */
{NEWLINE}       { System.out.printf("\nLinha: %d\n", ++lines); }
{COMMENT}       { lines+= yytext().split("\\r\\n|\\n|\\r", -1).length - 1; }

/* String Literal */
{STRING}        { System.out.printf("[string_literal, %s] ", yytext()); }

/* Palavras reservadas, Header e Dígitos */
{TYPES}         {
    System.out.printf("[reserved_word, %s] ", yytext());
    type = true;
}
{RESERVED_WORD} {
    String texto = yytext();
    System.out.printf("[reserved_word, %s] ", texto);

    if(texto.equals("for")) {
        isFor = true;
    }
}
{HEADER_FILE}   { System.out.printf("[standard_library, %s] ", yytext()); }
{DIGIT}         { System.out.printf("[num, %s] ", yytext()); }

/* Remoção de espaços em branco */
{SPACE}         { }

/* Variaveis */
{VARIABLE}       {
    String texto = yytext();
    boolean found = false;

    if(!type) {
        outerLoop:
        for (int e = escopo; e >= 0; e--) {
            for (int i = 0; i < idText[e].length; i++) {
                if(texto.equals(idText[e][i])) {
                    System.out.printf("[id, %d] ", id[e][i]);
                    found = true;
                    break outerLoop;
                } else if(idText[e][i] == null) {
                    break;
                }
            }
        }
    } else {
        definedVarOrFunc = true;
        type = false;
    }

    if(!found) {
        System.out.printf("[id, %d] ", lastId);

        for (int i = 0; i < idText[escopo].length; i++) {
            if(idText[escopo][i] == null) {
                id[escopo][i] = lastId++;
                idText[escopo][i] = texto;
                break;
            }
        }
    }
}

/* Operadores */
{RELATIONAL_OP}	{ System.out.printf("[relational_op, %s] ", yytext()); }
{LOGICAL_OP}	{ System.out.printf("[logic_op, %s] ", yytext()); }
{ARITH_OP}      { System.out.printf("[arith_op, %s] ", yytext()); }

/* Demais caracteres */
{EQUAL} 		{
    System.out.printf("[equal, %s] ", yytext());
    changeContext = false;
}
{L_PAREN}		{
    System.out.printf("[l_paren, %s] ", yytext());

    if(changeContext) {
        if(definedVarOrFunc) {
            isFunction = true;
            definedVarOrFunc = false;
            escopo++;
        } else if(isFor) {
            escopo++;
        }
    }
}
{R_PAREN}		{ System.out.printf("[r_paren, %s] ", yytext()); }
{L_BRACKET}		{
    System.out.printf("[l_bracket, %s] ", yytext());

    if(!isFunction && !isFor && changeContext) {
        escopo++;
    }

    isFunction = false;
    isFor = false;
}
{R_BRACKET}		{
    System.out.printf("[r_bracket, %s] ", yytext());

    if(changeContext) {
        for(int i = 0; i < id[escopo].length; i++) {
            id[escopo][i] = 0;
            idText[escopo][i] = null;
        }

        escopo--;
        isFor = false;
        isFunction = false;
    }
}
{L_SQ_BRACKET}	{ System.out.printf("[l_sq_bracket, %s] ", yytext()); }
{R_SQ_BRACKET}	{ System.out.printf("[r_sq_bracket, %s] ", yytext()); }
{COMMA}			{ System.out.printf("[comma, %s] ", yytext()); }
{SEMICOLON}		{
    System.out.printf("[semicolon, %s] ", yytext());
    changeContext = true;
    definedVarOrFunc = false;
}
{AMP}           { System.out.printf("[amp, %s] ", yytext()); }
.               {  }
