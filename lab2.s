;ARM1.s Source code for my program on the ARM Cortex M3

;1.Implement a program that will use 3 general purpose registers to perform storage and
;addition of hexadecimal numbers. Regardless of the actual registers, 
;well refer to them as Rx, Ry, and Rz.


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


Reset_Handler ;We only have one line of actual application code

; STEP 1, 2

	;MOV R0, #0x76 ; Move the 8 bit Hex number 76
	LDR R0, =0x00000001 ; Ry
	LDR R1, =0x00000002 ; Rz
	
	ADDS R2,R0,R1 ; ADD Ry,Rz and store to Rx
	
	PUSH {R0,R1,R2}

; STEP 3, 4, 5
	LDR R1, =0xFFFFFFFF ; Rz
	
	ADDS R2,R0,R1 ; ADD Ry,Rz and store to Rx
	
	PUSH {R0,R1,R2}
	
;STEP 7, 8

	LDR R0, =0x2 ; Ry
	
	ADDS R2,R0,R1 ; ADD Ry,Rz and store to Rx
	
	PUSH {R0,R1,R2}

;STEP 9, 8
	LDR R0, =0x7FFFFFFF ; Ry
	LDR R1, =0x7FFFFFFF ; Rz
	
	ADDS R2,R0,R1 ; ADD Ry,Rz and store to Rx
	
	PUSH {R0,R1,R2}
	
	B Reset_Handler
	
	ALIGN

	END