; Ficheiro de Assembly do P3
;
; Programa para desenvolvimento do e-fólio B.
;
; O vetor inicia-se na posição de memória 8000h
; sendo o número de elementos N_ELEM.
;
; Juntar dois vetores ordenados
; por ordem ascendente no vetor vazio.

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
			PUSH 5				;colocar o número de elementos da primeira parte do vetor na pilha(parâmetro 2)
			PUSH 8005h			;colocar o endereço de VETOR[5] na pilha (parâmetro 3)
			PUSH 2				;colocar o número de elementos da segunda parte do VETOR na pilha (parâmetro 4)
			PUSH 8010h			;colocar o endereço do VETOR vazio (parâmetro 5)
			PUSH N_ELEM			;colocar o número de elementos do VETOR vazio (parâmetro 6)
			CALL ALINEA_C		;chamar a Subrotina ALINEA_C (MergeList)
		
FIM:		JMP FIM				;Fim do programa

;Subrotina ALINEA_C (MergeList)

ALINEA_C:	MOV R1, R0			;inicializar iterador do primeiro vetor V1
			MOV R2, R0			;inicializar iterador do segundo vetor V2
			MOV R3, R0			;inicializar iterador do vetor vazio V
CicloC:		CMP R1, M[SP+6]		;comparar iterador de V1 com número de elementos de V1
			JMP.Z CicloCV2		;se atingiu o fim de V1, inserir restantes elementos de V2
			CMP R2, M[SP+4]		;comparar iterador de V2 com número de elementos de V2
			JMP.Z CicloCV1		;se atingiu o fim de V2, inserir restantes elementos de V1
			MOV R4, M[SP+7]		;obter o endereço de V1[0]
			ADD R4, R1			;obter o endereço de V1[i]
			MOV R5, M[SP+5]		;obter o endereço de V2[0]
			ADD R5, R2			;obter o endereço de V2[j]
			MOV R6, M[SP+3]		;obter o endereço de V[0]
			ADD R6, R3			;obter o endereço de V[k]
			MOV R7, M[R4]		;obter V1[i]
			CMP R7, M[R5]		;comparar V1[i] com V2[j]
			BR.P Else			;se V1[i]>V2[j], saltar para Else
			MOV M[R6], R7		;V[K]=V1[i]
			INC R1				;incrementar iterador de V1
			BR Seguinte			;saltar Else
Else:		MOV R7, M[R5]		;obter V2[j]
			MOV M[R6], R7		;V[k]=V2[j]
			INC R2				;incrementar iterador de V2
Seguinte:	INC R3				;incrementar iterador de V		
			BR CicloC			;saltar para CicloC1

CicloCV1:	CMP R1, M[SP+6]		;comparar iterador de V1 com indice máximo de V1
			BR.Z AC_FIM			;se atingiu o fim de V1, terminar ciclo e retornar
			MOV R4, M[SP+7]		;obter o endereço de V1[0]
			ADD R4, R1			;obter o endereço de V1[i]
			MOV R6, M[SP+3]		;obter o endereço de V[0]
			ADD R6, R3			;obter o endereço de V[k]
			MOV R7, M[R4]		;obter V1[i]
			MOV M[R6], R7		;V[K]=V1[i]
			INC R1				;incrementar iterador de V1
			INC R3				;incrementar iterador de V
			BR CicloCV1			;saltar para CicloCV1
			
CicloCV2:	CMP R2, M[SP+4]		;comparar iterador de V2 com indice máximo de V2
			BR.Z AC_FIM			;se atingiu o fim de V2, terminar ciclo e retornar
			MOV R5, M[SP+5]		;obter o endereço de V2[0]
			ADD R5, R2			;obter o endereço de V2[j]
			MOV R6, M[SP+3]		;obter o endereço de V[0]
			ADD R6, R3			;obter o endereço de V[k]
			MOV R7, M[R5]		;obter V2[j]
			MOV M[R6], R7		;V[K]=V2[j]
			INC R2				;incrementar iterador de V2
			INC R3				;incrementar iterador de V
			BR CicloCV2			;saltar para CicloCV2
			
AC_FIM:		RETN 6				;retornar, libertando os seis parâmetros de entrada