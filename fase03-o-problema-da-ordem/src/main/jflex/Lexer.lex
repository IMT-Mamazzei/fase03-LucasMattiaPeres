package br.maua.cic303;

import java_cup.runtime.Symbol; // Importação necessária para o CUP

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{

    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }

%}

/* ========================================================================= */
/* MACROS                                                                    */
/* ========================================================================= */

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Letter = [a-zA-Z]
Digit  = [0-9]

Number = {Digit}+

Identifier = {Letter}({Letter}|{Digit}|_){0,31}
OversizedIdentifier = {Letter}({Letter}|{Digit}|_){32}
%%

<YYINITIAL> {

    /* Espaços em branco */
    {WhiteSpace} { }

    /* ========================= */
    /* Palavras reservadas       */
    /* ========================= */

    "if"    { return symbol(sym.IF, yytext()); }
    "then"  { return symbol(sym.THEN, yytext()); }
    "else"  { return symbol(sym.ELSE, yytext()); }
    "while" { return symbol(sym.WHILE, yytext()); }

    /* ========================= */
    /* Pontuação                 */
    /* ========================= */

    "(" { return symbol(sym.LPAREN, yytext()); }
    ")" { return symbol(sym.RPAREN, yytext()); }
    "{" { return symbol(sym.LBRACE, yytext()); }
    "}" { return symbol(sym.RBRACE, yytext()); }
    ";" { return symbol(sym.SEMI, yytext()); }

    /* ========================= */
    /* Operadores relacionais    */
    /* ========================= */

    "==" { return symbol(sym.REL_OP, yytext()); }
    "!=" { return symbol(sym.REL_OP, yytext()); }
    "<=" { return symbol(sym.REL_OP, yytext()); }
    ">=" { return symbol(sym.REL_OP, yytext()); }
    "<"  { return symbol(sym.REL_OP, yytext()); }
    ">"  { return symbol(sym.REL_OP, yytext()); }

    /* ========================= */
    /* Atribuição                */
    /* ========================= */

    "="  { return symbol(sym.ASSIGN, yytext()); }

    /* ========================= */
    /* Operadores matemáticos    */
    /* ========================= */

    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    /* ========================= */
    /* Erro de identificador     */
    /* ========================= */

    {OversizedIdentifier} {
        return symbol(
            sym.error,
            "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext()
        );
    }

    /* ========================= */
    /* Identificadores e números */
    /* ========================= */

    {Identifier} {
        return symbol(sym.ID, yytext());
    }

    {Number} {
        return symbol(sym.NUMBER, yytext());
    }

    /* ========================= */
    /* Caracteres inválidos      */
    /* ========================= */

    . {
        return symbol(
            sym.error,
            "Erro Léxico: Caractere ilegal -> " + yytext()
        );
    }
}

/* EOF */
<<EOF>> {
    return symbol(sym.EOF, "");
}