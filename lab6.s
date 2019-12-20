;Objective:
;Configure the different LED's on ARM Cortex M3 microcontroller using general purpose I/O.

;;; Directives
            PRESERVE8
            THUMB      

       
;;; Equates

INITIAL_MSP EQU 0x20001000 ; Initial Main Stack Pointer Value


;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL EQU 0x40011000    ; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_CRH EQU 0x40011004    ;  Port Configuration Register for Px15 -> Px8
GPIOC_ODR EQU 0x4001100C	; (0x0C) Port Output Data Register
GPIOC_BSR EQU 0X40011010	; (0x14) Port Bit Reset Register

;Registers for configuring and enabling the clocks
;RCC Registers - Base Addr: 0x40021000
RCC_APB2ENR EQU 0x40021018  ;APB2 Peripheral Clock Enable Register	
	
;The offboard DIP Switch will be on port A bits 0 thru 3	
;PORT A GPIO - Base Addr: 0x40010800	
GPIOA_CRL EQU 0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOA_IDR EQU 0x40010808	; (0x08) Port Input Data Register

; Times for delay routines     
DELAYTIME EQU 1600000 ; (200 ms/24MHz PLL)

; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors DCD INITIAL_MSP ; stack pointer value when stack is empty
        DCD Reset_Handler ; reset vector

            AREA    MYCODE, CODE, READONLY
	EXPORT Reset_Handler
	ENTRY

Reset_Handler PROC

	BL GPIO_ClockInit
	BL GPIO_init


mainLoop
	
	BL Phase1
	;BL Phase2
	BL Phase3

	B mainLoop
	ENDP




;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ALIGN
		
Phase1 PROC
	LDR R6, = GPIOC_ODR ;intializes Port C for LED's 
	LDR R0,[R6]	
	ORR R0, #0X100	;setting bit 8 which is on Port C to turn on blue LED (PC 8)
	STR R0, [R6]

	BX LR
	ENDP

	ALIGN
		
Phase2 PROC
	LDR R8, =GPIOC_ODR 
	LDR R9, =DELAYTIME 
Loop1
	MOV R0, #0x100 ;intializing bit for Led PC8
	STR R0, [R8]	;LED is on
	SUB R9, #1	;decrementing loop by 1
	CMP R9, #0 
	BNE Loop1	;Branch back to loop1 until delay time = 0 
	LDR R9,=DELAYTIME ; Delaytime loop = 0
Loop2
	MOV R0, #0x200	;intializing bit for Led PC9
	STR R0, [R8]	;LED is on
	SUB R9, #1	;decrementing loop by 1
	CMP R9, #0
	BNE Loop2	;Branch back to loop2 until delay time = 0
	 	
	BX LR
	ENDP
		
	ALIGN
		
Phase3 PROC
	LDR R6, = GPIOA_IDR ;intializing Switch
	LDR R8, = GPIOC_ODR ;intializing output to LED
	LDR R0,[R6] ;storing R6 value to R0
	AND R0, #1	; Geting Least Significant Bit using and 
	CMP R0, #1	;Comparing it with 1
	BEQ Turn_On_Led ;turning on LED if input is 1  
	STR R0,[R8] ;or else LED is off
	B Phase3
	
Turn_On_Led
	LDR R8, = GPIOC_ODR ;intializing output to LED
	MOV R0, #0x300 ;Turning both LED ON 0011 0000 0000 when switch is detected
	STR R0,[R8] ;turn both LED on 
	B Phase3
	BX LR
	ENDP
		
;This routine will enable the clock for the Ports that you need
	ALIGN
		;; Enable peripheral clocks for various ports and subsystems
		; Bit 4: Port C, Bit 3: Port B, Bit 2: Port A
GPIO_ClockInit PROC

	LDR R6, = RCC_APB2ENR ; R6 is pointer to register
	MOV R0, #0x14      ;To turn on clocks for Ports A (bit 2) and Ports C (bit 4)
	STR R0, [R6]		;Turn on clocks for Ports A and C, store bits 2and 4 into the clock

	BX LR
	ENDP


	ALIGN


	;This routine enables the GPIO for the LED;s
	;; Set the config and mode bits for Port A bits 0 through 3 to Floating Input
GPIO_init  PROC

	LDR R6, = GPIOC_CRL    
	LDR R0, =0x44444444	 ;CNF: 01 (floating input), Mode: 00 (input)
	STR R0,[R6] ;Store R0 into the address of R6
	
	;; Set the config and mode bits for Port C bit 9/8 so they will
	;; be push-pull outputs (up to 50 MHz)

	LDR R7, = GPIOC_CRH
	LDR R0, =0x44444433	; CNF: 00 (floating input), Mode: 11 (input)
	STR R0, [R7]	;Store R0 into the address of R7


	BX LR
	ENDP


	ALIGN


	END