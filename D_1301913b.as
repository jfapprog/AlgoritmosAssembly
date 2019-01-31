; Ficheiro de Assembly do P3
;
; Programa para desenvolvimento do e-fólio B.
;
; O vetor inicia-se na posição de memória 8000h
; sendo o número de elementos N_ELEM.
;
; Ordenar os elementos do VETOR
; por ordem ascendente utilizando o algoritmo Bubble Sort.

;Constantes

ORD 		EQU 0001h			;vetor ordenado
NORD		EQU 0002h 			;vetor não ordenado
N_ELEM		EQU 7				;número de elementos do vetor

;Variáveis

			ORIG 8000h			;guardar variáveis a partir do endereço 8000h
VETOR		STR 2,3,4,5,6,1,8	;vetor inicializado
			ORIG 0000h			;iniciar instruções no endereço 0000h

;Inicialização do stack pointer (SP)

Inicio:		MOV R1, FDFFh		;obter endereço de ínicio da pilha
			MOV SP, R1			;iniciar a pilha no endereço FDFFh
		
;Programa

			PUSH VETOR			;colocar o endereço de VETOR[0] na pilha (parâmetro 1)
			PUSH N_ELEM			;colocar o número de elementos na pilha (parâmetro 2)
			CALL ALINEA_B		;chamar Subrotina ALINEA_B (BubbleSort)
		
FIM:		JMP FIM				;Fim do programa

;Subrotina ALINEA_B (BubbleSort)

ALINEA_B:	MOV R1, M[SP+2]		;inicializar iterador do ciclo externo no R1
			DEC R1				;com indice máximo do VETOR
CicloBe:	MOV R2, R0			;inicializar contador de trocas no R2
			MOV R3, R0			;inicializar o iterador do ciclo interno no R3
CicloBi:	CMP R3, R1			;comparar iterador interno com iterador extermo
			BR.Z FimCicloBi		;se são iguais, terminar ciclo interno
			MOV R4, M[SP+3]		;obter o endereço de VETOR[0]
			ADD R4, R3			;obter o endereço de VETOR[i]
			MOV R5, M[R4]		;obter VETOR[i]
			CMP R5, M[R4+1]		;comparar VETOR[i] com VETOR[i+1]
			BR.P Ordenar		;se VETOR[i]>VETOR[i+1], ordenar elementos
Ordenado:	INC R3				;incrementar iterador
			BR CicloBi			;continuar ciclo
FimCicloBi:	DEC R1				;decrementar iterador do ciclo externo
			CMP R1, R0			;comparar iterador externo com zero
			BR.Z AB_FIM			;se é zero, terminar ciclo externo e retornar
			CMP R2, R0			;comparar contador de trocas com zero
			BR.NZ CicloBe		;se não é zero, continuar ciclo
AB_FIM:		RETN 2				;retornar, libertando os dois parâmetros de entrada

Ordenar:	MOV R6, M[R4+1]		;obter VETOR[i+1] 
			MOV M[R4+1], R5		;copiar VETOR[i] para VETOR[i+1]
			MOV M[R4], R6		;copiar VETOR[i+1] para VETOR[i]
			INC R2				;incrementar contador de trocas
			BR Ordenado			;voltar para CicloBi