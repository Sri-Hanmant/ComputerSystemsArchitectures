;ARM1.s Source code for my program on the ARM Cortex M3

;Objective:

;1.Create a subroutine that will calculate the factorial of this integer and store it in a
;register. After returning from this subroutine, demonstrate you have calculated the the 
;factorial by debugging and investigate the register.

;2.Your program will count the vowels of these two strings and store that count in a
;register that is available in the main part of your program

; Directives
	PRESERVE8
	THUMB
		
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported
	AREA RESET, DATA, READONLY
	EXPORT 	__Vectors


__Vectors DCD 0x20002000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector
	
	ALIGN


;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
	ALIGN
Reset_Handler  PROC ;We only have one line of actual application code

	MOV R0, #0x00 ; Move the 8 bit Hex number 00 to low word of R0

	
	ALIGN
		
	LDR R0, = 0x00000005 ;  Load R0 with the 32 bit Hex number 00000005
	
	BL factorial
		
	LDR R0, =string1 
	BL vowelcheck
	
	LDR R0, =string2
	BL vowelcheck
	
		
	B Reset_Handler
	
	ALIGN
		
factorial PROC ;factorial subroutine
	
	CMP R0, #0  ;CMP is to compare if R0 is 0
	MOV R1, #1	;MOV to store 1 in R1
	BEQ finish  ;BEQ to branch if equal, when the comparision is valid
	
	SUBS R1,R0,#1 ;SUB to decrement R0 by 1
	MUL R2,R0, R1 ;MUL to multiply R1 with R0 and store in R2
	
fact_loop 	;loop to parse through 
	SUBS R1,#1      ;SUB to decrement R0 by 1
	MUL  R2, R2, R1 ;MUL to multiply R1 with R0 and store in R2
	CMP  R1, #1     ;CMP to compare if R1 is 1
	BNE fact_loop   
	
finish	;branch for ending loop if comparison is 0

	BX LR ; Exit loop
	ENDP ;END the PROC

	ALIGN
	
vowelcheck PROC ;vowelcheck subroutine

	
	LDRB R1, [R0] ; Load each byte of register R0 into R1
	
	CBZ R1,countdone
	
	CMP R1, #'a'
	BEQ vowelcount
	CMP R1, #'A'
	BEQ vowelcount
	
	CMP R1, #'e'
	BEQ vowelcount
	CMP R1, #'E'
	BEQ vowelcount
	
	CMP R1, #'i'
	BEQ vowelcount
	CMP R1, #'I'
	BEQ vowelcount
	
	CMP R1, #'o'
	BEQ vowelcount
	CMP R1, #'O'
	BEQ vowelcount
	
	CMP R1, #'u'
	BEQ vowelcount
	CMP R1, #'U'
	BEQ vowelcount
	
		ADD R0, #1	
		B vowelcheck
		
vowelcount  ;vowelcount to add number of vowels in a string
	ADDS R8, #1 ;increament by one when a vowel is detected 
	ADDS R0, #1  	
	B vowelcheck

countdone
	BX LR
	
	ENDP
		
string1
	DCB "ENSE 352 is fun and I am learning ARM assembly!",0

string2
	DCB "Yes I really love it!",0

		
	END