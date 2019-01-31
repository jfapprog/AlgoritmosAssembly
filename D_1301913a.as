; Ficheiro de Assembly do P3
;
; Programa para desenvolvimento do e-fólio B.
;
; O vetor inicia-se na posição de memória 8000h
; sendo o número de elementos N_ELEM.
;
; No resgisto R1 retorna-se 1 se o vetor estiver ordenado
; por ordem ascendente e 2 em caso contrário.

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

			PUSH VETOR			;colocar o endereço inicial do vetor na pilha (parâmetro 1)
			PUSH N_ELEM			;colocar o número de elementos na pilha (parâmetro 2)
			CALL ALINEA_A		;chamar Subrotina ALINEA_A (IsSort)
		
FIM:		JMP FIM				;Fim do programa

; Subrotina ALINEA_A (IsSort)

ALINEA_A:	MOV R1, ORD			;inicializar R1 a 1 (parte-se do princípio que VETOR está ordenado)
			MOV R2, M[SP+2]		;obter o número de elementos do VETOR
			DEC R2				;obter indice máximo do VETOR
			MOV R3, R0			;inicializar o iterador no R3
CicloA:		CMP R3, R2			;comparar iterador com o indice máximo
			BR.Z AA_FIM			;se são iguais, terminar ciclo
			MOV R4, M[SP+3]		;obter o endereço de VETOR[0]
			ADD R4, R3			;obter o endereço de VETOR[i]
			MOV R5, M[R4]		;obter VETOR[i]
			CMP R5, M[R4+1]		;comparar VETOR[i] com VETOR[i+1]
			BR.P NaoOrd			;se VETOR[i]>VETOR[i+1], terminar ciclo
			INC R3				;incrementar iterador
			BR CicloA			;continuar ciclo
NaoOrd:		MOV R1, NORD		;mudar valor de R1 para não ordenado
AA_FIM:		RETN 2				;retornar, libertando os dois parâmetros de entrada