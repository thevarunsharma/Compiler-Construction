/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

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
    int_const = 258,
    char_const = 259,
    float_const = 260,
    id = 261,
    string = 262,
    enumeration_const = 263,
    storage_const = 264,
    type_const = 265,
    qual_const = 266,
    struct_const = 267,
    enum_const = 268,
    DEFINE = 269,
    IF = 270,
    FOR = 271,
    DO = 272,
    WHILE = 273,
    BREAK = 274,
    SWITCH = 275,
    CONTINUE = 276,
    RETURN = 277,
    CASE = 278,
    DEFAULT = 279,
    GOTO = 280,
    SIZEOF = 281,
    PUNC = 282,
    or_const = 283,
    and_const = 284,
    eq_const = 285,
    shift_const = 286,
    rel_const = 287,
    inc_const = 288,
    point_const = 289,
    param_const = 290,
    ELSE = 291,
    HEADER = 292
  };
#endif
/* Tokens.  */
#define int_const 258
#define char_const 259
#define float_const 260
#define id 261
#define string 262
#define enumeration_const 263
#define storage_const 264
#define type_const 265
#define qual_const 266
#define struct_const 267
#define enum_const 268
#define DEFINE 269
#define IF 270
#define FOR 271
#define DO 272
#define WHILE 273
#define BREAK 274
#define SWITCH 275
#define CONTINUE 276
#define RETURN 277
#define CASE 278
#define DEFAULT 279
#define GOTO 280
#define SIZEOF 281
#define PUNC 282
#define or_const 283
#define and_const 284
#define eq_const 285
#define shift_const 286
#define rel_const 287
#define inc_const 288
#define point_const 289
#define param_const 290
#define ELSE 291
#define HEADER 292

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
