; Ficheiro de Assembly do P3
;
; Programa para desenvolvimento do e-fólio B.
;
; O vetor inicia-se na posição de memória 8000h
; sendo o número de elementos N_ELEM.
;
; Ordenar os elementos do VETOR
; por ordem ascendente utilizando o algoritmo Merge Sort.

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
			PUSH 8020h			;colocar um endereço auxiliar na pilha (parâmetro 3)
			CALL ALINEA_D		;chamar a função ALINEA_D (MergeSort)
		
FIM:		JMP FIM				;Fim do programa

;Subrotina ALINEA_C (MergeList)

ALINEA_C:	MOV R1, R0			;inicializar iterador do primeiro vetor V1
			MOV R2, R0			;inicializar iterador do segundo vetor V2
			MOV R3, R0			;inicializar iterador do vetor vazio V
CicloC:		CMP R1, M[SP+6]		;comparar iterador de V1 com indice máximo de V1
			JMP.Z CicloCV2		;se atingiu o fim de V1, inserir restantes elementos de V2
			CMP R2, M[SP+4]		;comparar iterador de V2 com indice máximo de V2
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

;Subrotina ALINEA_D (MergeSort)

ALINEA_D:	MOV R1, M[SP+3]		;obter o número de elementos do vetor V
			CMP R1, 0001h		;verificar se o número de elementos de V é 1
			JMP.Z AD_FIM		;se é 1, retornar
								
								;primeira metade
			SHRA R1, 1			;obter o número de elementos da primeira metade (n/2)
			PUSH M[SP+4]		;colocar na pilha endereço da primeira metade do vetor
			PUSH R1				;colocar na pilha número de elementos da primeira metade
			PUSH M[SP+4]		;colocar na pilha endereço auxiliar
			CALL ALINEA_D		;chamar recursivamente MergeSort
								
								;segunda metade
			MOV R1, M[SP+3]		;obter o número de elementos de V
			MOV R2, R1			;copiar o número de elementos de V para R2
			SHRA R1, 1			;dividir o número de elementos por dois
			SUB R2, R1			;obter o número de elementos da segunda metade
			MOV R3, M[SP+4]		;obter endereço de V
			ADD R3, R1			;obter endereço da segunda metade de V
			PUSH R3				;colocar na pilha endereço da segunda metade
			PUSH R2				;colocar na pilha número de elementos da segunda metade
			PUSH M[SP+4]		;colocar na pilha endereço auxiliar
			CALL ALINEA_D		;chamar recursivamente MergeSort
			
								;juntar as duas partes ordenadas
			MOV R1, M[SP+3]		;obter o número de elementos do vetor
			MOV R2, R1			;copiar número de elementos do vetor para R2
			SHRA R1, 1			;obter o número de elementos primeira metade (n/2)
			SUB R2, R1			;obter o número de elementos da segunda metade
			MOV R3, M[SP+4]		;obter endereço do vetor
			PUSH R3				;colocar na pilha endereço da primeira metade do vetor
			PUSH R1				;colocar na pilha número de elementos da primeira metade
			ADD R3, R1			;obter endereço da segunda metade do vetor
			PUSH R3				;colocar na pilha endereço da segunda metade
			PUSH R2				;colocar na pilha número de elementos da segunda metade
			PUSH M[SP+6]		;colocar na pilha endereço auxiliar
			PUSH M[SP+8]		;colocar na pilha número de elementos do vetor
			CALL ALINEA_C		;juntar as listas ordenadas, chamar MergeList
			
								;copiar elementos do vetor auxiliar para vetor original
			MOV R1, R0			;inicializar iterador
CicloD:		CMP R1, M[SP+3]		;comparar iterador com o número de elementos
			BR.Z AD_FIM			;se é igual, terminar ciclo e retornar
			MOV R2, M[SP+4]		;obter endereço de V[0]
			MOV R3, M[SP+2]		;obter endereço de Vaux[0]
			ADD R2, R1			;obter endereço de V[i]
			ADD R3, R1			;obter endereço de Vaux[i]
			MOV R4, M[R3]		;obter Vaux[i]
			MOV M[R2], R4		;V[i] = Vaux[i]
			INC R1				;incrementar iterador
			BR CicloD			;continuar CicloD

AD_FIM:		RETN 3				;retornar, libertando os 3 parâmetros de entrada