import java.io.*;

%%

%{

public String[] ids = new String[50];
public int lines = 0;
public int lastId = 0;

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
VARIABLE="&"*{WORD}{ARRAY}*|\*{SPACE}*\({WORD}\)|\*{SPACE}*{WORD}|[^A-Za-z_\n\r,]{SPACE}*\*{SPACE}*\({WORD}{SPACE}*"+"{SPACE}*{WORD}\)
STRING=\"([^\\\"]|\\.)*\"
DIGIT_INT=[0-9]+
DIGIT_FLOAT={DIGIT_INT}\.{DIGIT_INT}
DIGIT={DIGIT_INT}|{DIGIT_FLOAT}
RESERVED_WORD=#define|#include|void|float|int|char|string|double|clrscr|do|while|for|break|continue|switch|case|default|goto|printf|getch|scanf|if|else|return|NULL|null|asm|auto|const|static|short|signed|unsigned|sizeof|typedef|struct
HEADER_FILE=<{WORD}\.h>
COMMENT=(\/\/[^\r\n|\r|\n]*)|(\/\*([^\*]|\*+[^\*\/])*\*+\/)

RELATIONAL_OP="!="|"<"|"<="|"=="|">="|">"
LOGICAL_OP="||"|&&
ARITH_OP="++"|"+"|"-"|"*"|"/"

EQUAL==
COMMA=,
SEMICOLON=;
L_BRACKET="{"
R_BRACKET="}"
L_PAREN="("
R_PAREN=")"

%%

/* Remoção de linhas e comentários */
{NEWLINE}       { System.out.printf("\nLinha: %d\n", ++lines); }
{COMMENT}       { lines+= yytext().split("\\r\\n|\\n|\\r", -1).length - 1; }

/* String Literal */
{STRING}        { System.out.printf("[string_literal, %s] ", yytext()); }

/* Palavras reservadas, Header e Dígitos */
{RESERVED_WORD} { System.out.printf("[reserved_word, %s] ", yytext()); }
{HEADER_FILE}   { System.out.printf("[standard_library, %s] ", yytext()); }
{DIGIT}         { System.out.printf("[num, %s] ", yytext()); }

/* Remoção de espaços em branco */
{SPACE}         { }

/* Variaveis */
{VARIABLE}       {
    String texto = yytext();
    boolean found = false;

    for (int i = 0; i < lastId; i++) {
        if(texto.equals(ids[i])){
            System.out.printf("[id, %d] ", i);
            found = true;
            break;
        }
    }

    if(!found) {
        System.out.printf("[id, %d] ", lastId);
        ids[lastId++] = texto;
    }
}

/* Operadores */
{RELATIONAL_OP}	{ System.out.printf("[relational_op, %s] ", yytext()); }
{LOGICAL_OP}	{ System.out.printf("[logic_op, %s] ", yytext()); }
{ARITH_OP}      { System.out.printf("[arith_op, %s] ", yytext()); }

/* Demais caracteres */
{EQUAL} 		{ System.out.printf("[equal, %s] ", yytext()); }
{L_PAREN}		{ System.out.printf("[l_paren, %s] ", yytext()); }
{R_PAREN}		{ System.out.printf("[r_paren, %s] ", yytext()); }
{L_BRACKET}		{ System.out.printf("[l_bracket, %s] ", yytext()); }
{R_BRACKET}		{ System.out.printf("[r_bracket, %s] ", yytext()); }
{COMMA}			{ System.out.printf("[comma, %s] ", yytext()); }
{SEMICOLON}		{ System.out.printf("[semicolon, %s] ", yytext()); }
.               {  }
