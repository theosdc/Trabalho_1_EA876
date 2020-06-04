/******************************************************************************/
/* Trabalho 1 - Vinicius Hirono 188182 & Theo Camargo 206191                  */
/******************************************************************************/
/* Observacoes:                                                                *

  Com o fim de facilitar a compreencao do codigo em assembly, decidimos imprimir
  comentarios que mostram quais operacoes estao sendo resolvidas , o resultado
  final também é impresso.
  O formato seguido pelas operações eh POP B; POP A; OPERACAO; PUSH A;
  de modo a implementar a pilha do algoritmo Shift Reduce.
*                                                                             */
/* Definicoes-----------------------------------------------------------------*/

%{
#include <stdio.h>

void yyerror(char *c);
int yylex(void);
int pot_enable = 0; /* Indica se a subrotina de potenciacao deve ser impressa.
                      default: nao imprimir a subrotina */

int ini_enable = 1; /* Indica se a inicializacao deve ser impressa.
                      default: imprimir a inicializacao */
%}


/* Declaracao de tolkens
INT   - Numero inteiro;
SOMA  - Soma;
EOL   - "End of Line";
SUB   - Subtracao;
MULT  - Multiplicacao;
DIV   - Divisao;
POT   - Potenciacao;
ABRE  - Abre parenteses "(";
FECHA - Fecha parenteses ")";
*/
%token INT SOMA EOL SUB MULT DIV POT ABRE FECHA

/* Declaracao de precedencia, da menos prioritaria para a mais prioritaria */
%left SOMA
%left SUB
%left MULT
%left DIV
%left POT
%%

/* Regras---------------------------------------------------------------------*/

PROGRAMA:
  PROGRAMA EXPRESSAO EOL {
    ini_enable = 1;  /* Prepara para  uma nova expressao */
    printf("\n;Fim do programa principal\nHLT\n");
    printf("\n;Resultado: %d\n", $2); /* A fim de facilitar testes, imprimimos o
                                      resultado esperado */

    if(pot_enable == 1){ /* Caso em que a subrotina de potenciacao deve ser
                            impressa */
        printf("\n;Subrotina de Potenciacao\n\n");
        printf("potencia:\nMUL C\nDEC B\nJNZ potencia\nRET\n");
        pot_enable = 0;
      }
    }
    |
    ;

EXPRESSAO:
  INT { /* INTEIRO */
    $$ = $1;
    if(ini_enable == 1) { /* Inicializacao */
      printf(";Programa principal\n\n");
      ini_enable = 0;
    }
	  printf("PUSH %d\n", $1); /* Coloca o inteiro na pilha */
  }

  | ABRE EXPRESSAO FECHA  { /* Tratamento de Parenteses */
    /* Nota-se que nao sao geradas instrucoes em assembly, porem esta regra eh
    importante para garantir a correta precedencia das operacoes */
    printf(";Tirei parenteses em %d\n", $2);
    $$ = $2;
  }

  | EXPRESSAO POT EXPRESSAO { /* Tramento de Potenciacao */
    /* Calcula o resultado da potencicao */
    int res; res = 1;
    for(int i = 0; i < $3; i++){res = res * $1;}
    printf("\n;Operacao: %d ^ %d = %d\n", $1, $3,res);

    /* Casos para a potenciao */
    if ( $3 == 0 ) { /* Expoente igual a zero */
      printf("POP B\nPOP A\nMOV A, 1\nPUSH A\n");
    } else {

      if ($3 == 1){ /* Expoente igual a um */
      printf("POP B\nPOP A\nPUSH A\n");
      } else{

      /*Expoente diferente de zero e um*/
      printf("POP B\nPOP A\nMOV C,A\nDEC B\nCall potencia\nPUSH A\n");

      /* Foi criada uma subrotina "potencia" para realizar a exponencicao.
      A variavel "pot_enable" indica se essa subrotina sera impressa ao final
      do programa */

      pot_enable = 1; /* Indica que a subrotina deve ser impressa */
     }
     $$ = res;
     printf(";\n");
    }}

  | EXPRESSAO DIV EXPRESSAO  { /* Tratamento de Divisao */
    printf("\n;Operacao: %d / %d = %d\n", $1, $3, $1/$3);
    printf("POP B\nPOP A\nDIV B\nPUSH A\n");
    printf(";\n");
    $$ = $1 / $3;
    }

  | EXPRESSAO MULT EXPRESSAO  { /* Tratamento de Multiplicacao */
    printf("\n;Operacao: %d * %d = %d\n", $1, $3, $1*$3);
  	printf("POP B\nPOP A\nMUL B\nPUSH A\n");
    printf(";\n");
    $$ = $1 * $3;
    }

  | EXPRESSAO SOMA EXPRESSAO  { /* Tratamento de Soma */
    printf("\n;Operacao: %d + %d = %d\n", $1, $3, $1+$3);
    printf("POP B\nPOP A\nADD A, B\nPUSH A\n");
    printf(";\n");
    $$ = $1 + $3;
    }

  | EXPRESSAO SUB EXPRESSAO { /* Tratamento de Subtracao */
    printf("\n;Operacao: %d - %d = %d\n", $1, $3, $1-$3);
    printf("POP B\nPOP A\nSUB A, B\nPUSH A\n");
    printf(";\n");
    $$ = $1 - $3;
    }
  ;

%%

/* Codigo---------------------------------------------------------------------*/


void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;

}
