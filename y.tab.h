/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PAR_OPEN = 258,
    PAR_CLOSE = 259,
    COMMA = 260,
    SEMICOLON = 261,
    WHILE = 262,
    RETURN = 263,
    IF = 264,
    ELSE = 265,
    CB_OPEN = 266,
    CB_CLOSE = 267,
    PLUS = 268,
    MINUS = 269,
    ASTERISK = 270,
    SLASH = 271,
    ASSIGNMENT = 272,
    OR = 273,
    AND = 274,
    NOT = 275,
    LESS = 276,
    LESS_EQUAL = 277,
    MORE_EQUAL = 278,
    MORE = 279,
    EQUAL = 280,
    NOT_EQUAL = 281,
    QUOT = 282,
    NUMBER = 283,
    LITERAL_C = 284,
    ID = 285,
    CHAR = 286,
    INT = 287
  };
#endif
/* Tokens.  */
#define PAR_OPEN 258
#define PAR_CLOSE 259
#define COMMA 260
#define SEMICOLON 261
#define WHILE 262
#define RETURN 263
#define IF 264
#define ELSE 265
#define CB_OPEN 266
#define CB_CLOSE 267
#define PLUS 268
#define MINUS 269
#define ASTERISK 270
#define SLASH 271
#define ASSIGNMENT 272
#define OR 273
#define AND 274
#define NOT 275
#define LESS 276
#define LESS_EQUAL 277
#define MORE_EQUAL 278
#define MORE 279
#define EQUAL 280
#define NOT_EQUAL 281
#define QUOT 282
#define NUMBER 283
#define LITERAL_C 284
#define ID 285
#define CHAR 286
#define INT 287

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 60 "c_simple_parser.y" /* yacc.c:1909  */
 char * intval;
        char  charval;
        struct symtab *symp;
        //struct exval *test;
        

#line 125 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
