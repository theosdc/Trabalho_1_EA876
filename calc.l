/******************************************************************************/
/* Trabalho 1 - Vinicius Hirono 188182 & Theo Camargo 206191                  */
/******************************************************************************/

/* Definicoes-----------------------------------------------------------------*/

%{
#include <stdlib.h>
#include <stdio.h>
void yyerror(char *);

#include "y.tab.h"
%}

/* Regras---------------------------------------------------------------------*/


%%

[0-9]+  {
          yylval = atoi(yytext);
          return INT;
        }

[+]     {
          return SOMA;
        }

[-]     {
          return SUB;
        }

[*]     {
          return MULT;
        }

[\^]     {
          return POT;
        }


[/]     {
          return DIV;
        }

[(]     {
          return ABRE;
        }

[)]     {
          return FECHA;
        }


\n   {
         return EOL;
       }

[ \t]+ ;

. {yyerror("Token nao reconhecido!\n");}

%%

/* Codigo---------------------------------------------------------------------*/



int yywrap() {
  return 1;
}
