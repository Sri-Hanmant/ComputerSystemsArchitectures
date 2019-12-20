;ARM1.s Source code for my program on the ARM Cortex M3

;Objective: Manipulations using the ARM assembly instruction set.

; Directives
	PRESERVE8
	THUMB
		
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported
	AREA RESET, DATA, READONLY
	EXPORT 	__Vectors


__Vectors 
	DCD 0x20002000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector
	
	ALIGN


;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
	ALIGN
Reset_Handler  PROC ;We only have one line of actual application code

	LDR R0, =0x00000005
	
	
mainLoop

	;BL bitCheck11
	;BL bitClear
	;BL count1
	BL rot_left_right
	
	B Reset_Handler
	ENDP

;The function of the subroutine is to determine if bit 11 is a
;1 or a 0. R1 will contain the answer (1 for true and 0 for false)
bitCheck11 PROC
	
	MOV R0, #0x0000 ;input for R0
	AND R2, R0, #0x0800 ;isolating bit 11
	CMP R2, #0x0800 ;comparing bit 11 to check if value is 1
	
	BEQ bit1		
	
	MOV R1, #0x0000; if not equal then 0
	
	BX LR
	ENDP
		
bit1 PROC
	
	mov R1, #0x0001 ;setting r1 to 1 
	pop{R0,R1}
	pop{LR}
	
	BX LR	
	ENDP

;This subroutine will be responsible for setting
;bit 3 and clearing bit 7. All other bits shall be left undisturbed.
bitClear PROC
	
	MOV R2, #0xFF7F ;clearing bit 7
	AND R0, R0, R2
	ORR R0, R0, #0x0008 ;setting bit 3
	
	BX LR	
	ENDP	
;The function of the subroutine shall be to count the
;number of 1’s that are resident in R0 (the input). Count the 1’s and put the answer in R1.
count1 PROC
	
	MOV R3, #0x0001
	CMP R0, #0x00000000 ;checking to see if  R0 is empty
	
	BEQ done
	AND R2, R0, #0x0001 ;Isolating bit 0, store is r2
	CMP R3, R2 ; comparing bit 0 to 1
	BEQ count ;condition for branch
	LSR R0, R0, #0x0001 ;right shift R0 value by 1
	
	CMP R0, #0x00000000 ; checking to see if R0 is 0
	BEQ done	;going to end of subroutine
	
	B count1 ;looping back to beginning of subroutine
	
count
	
	ADD R1, #0x1 ;add 1 to R1 if comparison is valid
	LSR R0, R0, #0x0001 ;right shift R0 by 1
	B count1 ; looping to beginning of count subroutine
	
done 
	BX LR
	ENDP

;The following function rotates Left or Right the lower 16 bits(without touching the upper 16 bits).
rot_left_right PROC
	
	LDR R0, =0x1234F05C ;loading the input for code
	LDR R7, =0xFFFF
	AND R1, R0, R7
	MOV R2, #0x00000025;bit 5 is which way to rotate, bits 0-3 are how many times to rotate
	
	AND R3, R2, #0x0020
	AND R2, R2, #0x0007			
	
	CMP R3, #0x0020
	BEQ rot_left
	
	
rot_right

	AND R4, R1, #0x0001
	LSR R1, #1
	LSL R4, #15 ;left shift the value for bit 1 by 15
	ORR R1, R1, R4 ;combining the last bit with shifted value
	
	SUB R2, #1
	CMP R2, #0
	BEQ done1	
	B rot_right



rot_left

	AND R4, R1, #0x8000
	LSL R1, #1
	AND R1, R7
	LSR R4, #15
	ORR R1, R1, R4
	
	SUB R2, #1
	CMP R2, #0
	BEQ done1	
	B rot_left
	
	
done1
	LDR R3, =0xFFFF0000
	AND R0, R3
	ORR R0,R1
	BX LR
	ENDP
	
	
	ALIGN	
	end

	