LEX = flex
YACC = yacc -d

CC = gcc

compiler: lex.yy.o y.tab.o
	$(CC) -o compiler lex.yy.o y.tab.o -ll -ly -lm

lex.yy.o: lex.yy.c y.tab.h
y.tab.o: y.tab.c

y.tab.c y.tab.h: c_simple_parser.y symbol_table.h
	$(YACC) c_simple_parser.y

lex.yy.c: c_simple_lexer.l symbol_table.h
	$(LEX) c_simple_lexer.l

clean:
	-rm -f *.o lex.yy.c *.tab.* compiler *.output *.out
